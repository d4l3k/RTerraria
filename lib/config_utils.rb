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
end
