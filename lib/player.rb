class Player
attr_accessor :name, :inventory, :x, :y, :connection, :id, :world, :buffs, :hair_style, :gender, :hair_color, :skin_color, :eye_color, :shirt_color, :undershirt_color, :pants_color, :shoe_color
	def initialize name
		@name = name
		@health = 0
		@max_health = 0
		@mana = 0
		@max_health = 0
		@buffs=[]
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
	def set_mana mana
	  if(mana>@max_mana)
	    @mana = @max_mana
	  else
	    @mana = mana
	  end
	end
	def set_max_mana mana
	  @max_mana = mana
	end
	def to_s
	  return "#<Player:#{@id} @name=#{@name} @world=#{@world.name}>"
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
