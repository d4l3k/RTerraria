class GeneratorHandeler
	def initialize server
		@server = server
		@config_worlds = server.config.worlds
		@server.log.info("Terrain Generator enabled.")
	end
	def generate_chunk world, x
		chunk = Chunk.new @server, world, x
		generators = world.config.generators
		generators.each do |generator|
			generator::generate_chunk(chunk, world.seed, x)
		end
		return chunk
	end
end
