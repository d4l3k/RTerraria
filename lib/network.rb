require 'eventmachine'

class Connection < EventMachine::Connection
	attr_accessor :server, :log
	@server
	@log
	def initialize
	end
	def post_init
	  	@log.info "Client connected!"
	end
	def receive_data data
		@server.protocol.read_packet self, data
	end
	def unbind
		@log.info "Client disconnected."
	end
end
