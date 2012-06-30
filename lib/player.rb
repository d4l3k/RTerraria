class Player
  attr_accessor :name, :inventory, :x, :y, :connection, :id, :world, :raw_data
	def initialize name
		@name = name
		@health = 0
		@max_health = 0
	end
	def set_health health
	  if(health>@max_health)
	    @health = @max_health
	  else
	    @health = health
	  end
	end
	def set_max_health health
	  @max_health = health
	end
end

class Item
  attr_accessor :amount, :prefix, :id
  def initialize amount, prefix, id
    @amount = amount
    @prefix = prefix
    @id = id
  end
end
