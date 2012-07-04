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
end
