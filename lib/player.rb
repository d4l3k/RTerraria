class Player
attr_accessor :name, :inventory, :x, :y, :z, :connection, :id, :world
	def initialize name
		@name = name
		@id = rand(0..2147483647)
	end
end
