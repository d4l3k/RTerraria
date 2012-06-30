module BasicHandler
  def connection_request data
    @log.info("New Client. Version: #{data[:version]}")
    @log.debug("Selecting default world...")
    world_select = @server.worlds[0]
    @server.worlds.each do |world|
      if world.name == @config.default_world
        world_select = world
      end
    end
    @log.debug("Default world is #{world_select.name}")
    connection_response connection, world_select
  end
end
