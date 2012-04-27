module Coronet
  class Listener < GServer
    attr_accessor :port
    attr_accessor :protocol
    attr_accessor :mediator_klass
    
    def initialize(port, protocol) #, mediator_klass) #callback=nil)
      @port     = port
      @protocol = protocol
      super(port)
    end
    
    def uses_mediator_class(mediator_klass); @mediator_klass = mediator_klass; end
    
    def serve(io)
      request = @protocol.read(io)
      response = @mediator_klass.handle(request)
      @protocol.write(response, io)
    end
  end
end