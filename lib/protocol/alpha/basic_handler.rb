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
    @log.debug("Selecting default world...")
    world_select = @server.worlds[0]
    @server.worlds.each do |world|
      if world.name == @config.default_world
        world_select = world
      end
    end
    @log.debug("Default world is #{world_select.name}")
    player = world_select.load_player(event[:player_name], connection)
    player.raw_data = bytes
  end
  def BasicHandler.inventory_data event
    player = event[:connection].player
    player.inventory[event[:inventory_slot]]=Item.new(event[:item_id],event[:item_prefix],event[:item_stack])
  end
end
