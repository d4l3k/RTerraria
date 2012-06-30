class WorldConfig
	attr_accessor :name, :seed, :generators
	def initialize name, seed, generators
		@name = name
		@seed = seed
		@generators = generators
		return [self]
	end
end

class Configuration
attr_accessor :interface, :port, :max_players, :description, :motd, :minversion, :maxversion, :protocols, :authenticate, :worlds, :default_world, :log_level
  def initialize server
    @events = {}
    config
  end
  def register_event event, handlers
   @events[event]=handlers
  end
  def handle_event event, data
    if @events[event]!=nil
      cancel = false
      @events[event].each do |handler|
        if !cancel
          response = handler.send event, data
          if response == true
            cancel = true
          end
        end
      end
      return true
    else
      return false
    end
  end
end
