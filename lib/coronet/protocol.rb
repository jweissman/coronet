module Coronet
  class Protocol
    attr_accessor :message_format
    attr_accessor :transport_mechanism
    
    def initialize(message_format, transport_mechanism)
      @message_format        = message_format
      @transport_mechanism   = transport_mechanism
    end
    
    def read(io)
      packed = @transport_mechanism.read(io)
      unpacked = @message_format.unpack(packed)
      unpacked
    end
    
    def write(data, io)
      packed = @message_format.pack(data)
      @transport_mechanism.write(packed, io)
    end
    
    def transmit(request, host, port)
      io = @transport_mechanism.open(host,port)
      write(request, io)
      response = read(io)
      @transport_mechanism.close(io)
      response
    end
  end
end