# This file handles most of the event processing. It handles almost all of it.
class Configuration
  def register_event event, handlers
   @events[event]=handlers
  end
  def handle_event event, data
    data = Event[data]
    if @events[event]!=nil
      cancel = false
      @events[event].each do |handler|
        if !cancel
          response = handler.send event.to_sym, data
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

class Event < Hash
  def respond data
   # This should probably be configurable to use multiple protocols.
   self[:connection].send_data $server.protocol.protocols[0].build_packet data
  end
end
