module Coronet
  class RemoteEndpoint
    attr_accessor :host, :port
    attr_accessor :protocol
    
    def initialize(host, port, protocol)
      @host = host
      @port = port
      @protocol = protocol
    end
    
    def transmit(request)
      @protocol.transmit(request, @host, @port)
    end
  end
end