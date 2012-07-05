class Chunk
attr_accessor :blocks, :x
	def initialize server, world, x
		@x = x
		@blocks = Array.new(16) { Array.new(world.height) { Block.new(0) }}
	end
	def marshal_dump
		[ @x, @blocks ]
	end
	def marshal_load array
		@x, @blocks = array
	end
end
