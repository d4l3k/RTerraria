class Connection < EventMachine::Connection
	attr_accessor :player
	def initialize
	end
	def post_init
	end
	def receive_data data
		$server.protocol.read_packet self, data
	end
	def unbind
		if @player!=nil
			world = @player.world
			name = @player.name
			world.save_player name
			world.remove_player name
			$log.info "Client (#{name}) disconnected."
		else
			$log.info "Client (Unknown) disconnected."
		end
	end
	def to_s
	  return "#<Connection:#{@object_id} @signature=#{@signature}>"
	end
end
