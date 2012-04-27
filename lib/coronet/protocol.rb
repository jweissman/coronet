module Coronet
  class Protocol
    attr_accessor :message_format
    attr_accessor :transport_mechanism
    
    def initialize(message_format, transport_mechanism)
      @message_format        = message_format
      @transport_mechanism   = transport_mechanism
    end
    
    def read(io)
      # packed = 
      # unpacked = 
      @message_format.unpack(@transport_mechanism.read(io))
      # unpacked
    end
    
    def write(data, io)
      @transport_mechanism.write(@message_format.pack(data), io)
    end
    
    def transmit(request, host, port)
      # puts "=== opening connection to #{host}:#{port}"
      io = @transport_mechanism.open(host,port)
      # puts "--- writing #{request} to #{host}:#{port}"
      write(request, io)
      # puts "=== reading response from #{host}:#{port}"
      response = read(io)
      # puts "--- closing socket to #{host}:#{port}"
      @transport_mechanism.close(io)
      # puts "=== returning response #{response} from #{host}:#{port}"
      response
    end
  end
end