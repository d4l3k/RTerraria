class AlphaProtocol
  def init_packets
    @players
    @last_keep_alive = 0
    @delim = "\xA7"
  end

  def initialize server
    @server = server
    @log = server.log
    @config = server.config
    @players = server.players
    init_packets()
    @log.info("AlphaProtocol Enabled!")
  end

  def read_packet connection, packet
    length = packet[0..3].unpack("V")[0]
    packet_key = packet[4].unpack("C")[0]
    packet_id = packet_ids.key(packet_key)
    @log.debug("Recieved Packet Id: #{"0x%02X" % packet_key} (#{packet_id.to_s}), length: #{length}.")
    if packet_id!=nil&&packet_components[packet_id]!=nil
      packet_index = 5
      packet_parts = {:length=>length,:id=>packet_key,:type=>packet_id, :connection=>connection, :player=>connection.player}
      packet_components[packet_id].each do |key, type|
        data = nil
        if type==:byte
          # Single byte, unsigned
          data = packet[packet_index].unpack("C")[0]
          packet_index+=1
        elsif type == :int16
          # Integer 16-bit signed, small-endian
          data = packet[packet_index..(packet_index+1)].unpack("s<")[0]
          packet_index+=2
        elsif type == :int32
          # Integer 32-bit signed, small-endian
          data = packet[packet_index..(packet_index+3)].unpack("l<")[0]
          packet_index+=4
        elsif type == :single
          # Single precision float
          data = packet[packet_index..(packet_index+3)].unpack("g")[0]
          packet_index+=4
        elsif type == :color
          # 3 bytes
          data = packet[packet_index..(packet_index+2)].unpack("CCC")[0..2]
          packet_index+=3
        elsif type == :string
          # String
          data = packet[packet_index..packet.length].to_s
        end
        packet_parts[key]=data
      end
      response = $configuration.handle_event packet_id, packet_parts
      if !response
        @log.debug("TODO: Add handler for #{"0x%02X" % packet_key} (#{packet_id}). No handlers found!")
        @log.debug("PACKET DUMP: #{packet_parts}")
      end
    else
      @log.debug("TODO: Implement #{"0x%02X" % packet_key} (#{packet_id}). Ignoring!")
    end
  end
  def build_packet data
    # Checks to see if a valid :type is provided. If not it converts the :id (the :id is the numerical value of the packet. 0x01 vs :connection_request)
    $log.debug(data)
    if data[:type]==nil
      data[:type]==packet_ids.key(data[:id])
    end
    # converts :type to :id
    if data[:id]==nil
      data[:id]=packet_ids[data[:type]]
    end
    # Packs the id into byte form.
    packet = [data[:id]].pack("C")
    
    packet_components[data[:type]].each do |key, type|
      if type==:byte
        #data = [packet[packet_index]].unpack("C")[0]
        packet+=[data[key]].pack("C")
      elsif type==:byte_array
        packet+=data[key].pack("C*")
      elsif type == :int16
        #data = [packet[packet_index..(packet_index+1)]].unpack("n")[0]
        packet+=[data[key]].pack("n")
      elsif type == :int32
        #data = [packet[packet_index..(packet_index+3)]].unpack("N")[0]
        packet+=[data[key]].pack("N")
      elsif type == :single
        #data = [packet[packet_index..(packet_index+3)]].unpack("g")[0]
        packet+=[data[key]].pack("g")
      elsif type == :color
        #data = [packet[packet_index..(packet_index+2)]].unpack("CCC")[0..2]
        packet+=data[key].pack("CCC")
      elsif type == :string
        #data = packet[packet_index..packet.length].to_s
        packet+=data[key]
      end
    end
    return [packet.length].pack("V")+packet
  end
end
=begin
    when packets[:connection_request]
    	connection_request connection, length, packet
    when packets[:player_data]
      player_data connection, length, packet
    when packets[:player_health_update]
      player_health_update connection, length, packet
    when packets[:inventory_data]
      inventory_data connection, length, packet
    when packets[:world_request]
      world_data connection
      #disconnect connection, "Potato"
    when packets[:request_tile_block]
      request_tile_block connection,packet
    else
      @log.debug("TODO: Implement #{"0x%02X" % packet_id} (#{packets.key(packet_id).to_s}). Ignoring!")
    end
  end

  def connection_response connection, world
    packet = [world.players.length].pack("C")
    send_packet connection, :connection_response, packet
  end
  def player_data connection, length, packet
    bytes = packet[5,30].unpack("C*")
    # Proccess these bytes
    player_name = packet[30..packet.length].to_s
    @log.info("Login: #{player_name} has joined the server.")
    @log.debug("Selecting default world...")
    world_select = @server.worlds[0]
    @server.worlds.each do |world|
      if world.name == @config.default_world
        world_select = world
      end
    end
    @log.debug("Default world is #{world_select.name}")
    player = world_select.load_player(player_name, connection)
    player.raw_data = bytes
  end
  def disconnect connection, reason
	  send_packet connection, :disconnect, "potato"
	end
	def player_health_update connection, length, packet
	  parse = packet.unpack("VCnn")
	  connection.player.set_max_health parse[3]
	  connection.player.set_health parse[2]
	end
	def inventory_data connection, length, packet
	  parse = packet.unpack("VCCCCCn")
	  connection.player.inventory[parse[3]]=Item.new(parse[4],parse[5],parse[6])
	end
	def world_data connection
	  #Time
	  packet = [0].pack("l>")
	  #Day
	  packet += [1].pack("C")
	  #Moon Phase
	  packet += [0].pack("C")
	  #Blood Moon
	  packet += [0].pack("C")
	  # Max Tiles X
	  packet += [100000].pack("l>")
	  # Max Tiles Y
	  packet += [100000].pack("l>")
	  # Spawn Tile X
	  world = connection.player.world
	  packet += [world.spawnx].pack("l>")
	  # Spawn Tile Y
	  packet += [world.spawny].pack("l>")
	  # World Surface
	  packet += [75].pack("l>")
	  # Rock Layer
	  packet += [100].pack("l>")
	  # World ID
	  packet += [@server.worlds.index(world)].pack("l>")
	  # Flags - Downed bosses
	  packet += [0].pack("C")
	  # Worldname
	  packet += world.name
	  send_packet connection, :world_data, packet 
	end
	def request_tile_block connection, packet
	  parse = packet.unpack("VCl>*")
	  puts parse.to_s
	end
	def send_packet connection, id, packet
	  packet = [packets[id]].pack("C")+packet
	  # Pack the length and the data.
	  connection.send_data [packet.length].pack("V")+packet
	end
end
=end
