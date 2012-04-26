module Coronet
  class Listener < GServer
    attr_accessor :port
    attr_accessor :protocol
    attr_accessor :callback
    
    def initialize(port, protocol, callback=nil)
      @port     = port
      @protocol = protocol
      @callback = callback
      
      # start listening on port
      super(port)
    end
    
    def serve(io)
      request = @protocol.read(io)
      puts "--- listener invoking callback with request: #{request}"
      response = callback.call(request)
      puts "--- listener got response: #{response}"
      @protocol.write(response, io)
      # io.close
    end
  end
end