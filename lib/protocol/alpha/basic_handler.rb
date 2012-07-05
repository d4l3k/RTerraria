module BasicHandler
  def BasicHandler.connection_request event
    $log.info("New Client. Version: #{event[:version]}")
    $log.debug("Selecting default world...")
    world_select = $server.worlds[0]
    $server.worlds.each do |world|
      if world.name == $configuration.default_world
        world_select = world
      end
    end
    #$log.debug("Default world is #{world_select.name}")
    event.respond( { :type=>:connection_response, :player_slot=>world_select.players.length } )
  end
  def BasicHandler.player_data event
    $log.info("Login: #{event[:player_name]} has joined the server.")
    $log.debug("Selecting default world...")
    world_select = $server.worlds[0]
    $server.worlds.each do |world|
      if world.name == $configuration.default_world
        world_select = world
      end
    end
    $log.debug("Default world is #{world_select.name}")
    player = world_select.load_player(event[:player_name], event[:connection])
    #player.raw_data = bytes
    # :hair_style, :gender, :hair_color, :skin_color, :eye_color, :shirt_color, :undershirt_color, :pants_color, :shoe_color
    player.hair_style = event[:hair_style]
    player.gender = event[:gender]
    player.hair_color = event[:hair_color]
    player.skin_color = event[:skin_color]
    player.eye_color = event[:eye_color]
    player.shirt_color = event[:shirt_color]
    player.undershirt_color = event[:undershirt_color]
    player.pants_color = event[:pants_color]
    player.shoe_color = event[:shoe_color]
  end
  def BasicHandler.player_health_update event
    event[:player].set_max_health event[:max_health]
	  event[:player].set_health event[:current_health]
  end
  def BasicHandler.player_mana_update event
    event[:player].set_max_mana event[:max_mana]
	  event[:player].set_mana event[:current_mana]
  end
  def BasicHandler.inventory_data event
    event[:player].inventory[event[:inventory_slot]]=Item.new(event[:item_id],event[:item_prefix],event[:item_stack])
  end
  def BasicHandler.player_buffs event
    event[:player].buffs=[event[:buff1], event[:buff2], event[:buff3], event[:buff4], event[:buff5], event[:buff6], event[:buff7], event[:buff8], event[:buff9], event[:buff10]]
  end
  def BasicHandler.world_request event
	  world = event[:player].world
	  event.respond({ 
	    :type=>:world_data,
	    :game_time=>0, 
	    :day_time=>1,
	    :moon_phase=>0,
	    :blood_moon=>0,
	    :map_width=>world.loaded_chunks.length*16,
	    :map_height=> world.height, 
	    :spawn_tile_x=> world.spawnx, 
	    :spawn_tile_y=> world.spawny, 
	    :ground_level=> 1000, 
	    :rock_level => 1500, 
	    :world_id=> $server.worlds.index(world), 
	    :flags => 0, :world_name=>world.name })
  end
  def BasicHandler.request_tile_block event
    #$log.debug("Request_tile_block EVENNTNTNTNTNTNTNNTNTNTNT")
    event.respond( {:type => :statusbar_text, :num_msg => 5, :message=>"Potato"} )
    event[:player].world.loaded_chunks.each do |chunk|
      #$log.debug("CHUNK!")
      y = 0
      chunk.blocks[0].length.times do
        #$log.debug("YYYYY!")
        x = 0
        last_type = nil
        last_x = nil
        chunk.blocks.length.times do
          #$log.debug("XXXXXX")
          block = chunk.blocks[x][y]
          type = block.type
          if last_type==nil
            last_type=type
            last_x = x
          elsif last_type!=type
            flags = [0]
            if last_type != 0
              flags[0]=0
              flags[1]=last_type
            else
              flags[0]=1
            end
            tile_x = (chunk.x*16+last_x)
            length = (x-last_x)
            event.respond({:type=>:send_tile_row,:tile_x=>tile_x,:tile_y=>y,:flags=>flags,:amount=>length,:width=>length})
            $log.debug("Send tile block: #{tile_x}, #{y}. Length: #{length}")
            last_type=type
            last_x = x
          end
          x+=1
        end
        flags = [0]
        if last_type == 0
          flags[0]=1
          flags[1]=last_type
        end
        tile_x = (chunk.x*16+last_x)
        length = (x-last_x)
        event.respond({:type=>:send_tile_row,:tile_x=>tile_x,:tile_y=>y,:flags=>flags,:amount=>length,:width=>length})
        $log.debug("Send tile block: #{tile_x}, #{y}. Length: #{length}")
        y+=1
      end
    end
    #event.respond( {:type=>:send_spawn} )
  end
end
