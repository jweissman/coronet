module Coronet
  class Mediator
    attr_accessor :listener, :remote_endpoint
    
    def initialize(opts={}, &block) 
      with_listener(opts[:listener])  if opts.has_key? :listener
      using_endpoint(opts[:endpoint]) if opts.has_key? :endpoint
      
      instance_eval &block if block_given?
    end
    
    def with_listener(listener)
      @listener = listener
      @listener.callback = method(:handle)
      self
    end
    
    def using_endpoint(remote_endpoint)
      @remote_endpoint = remote_endpoint
      self
    end
    
    def local(message_format, transport_mechanism, port)
      protocol = Protocol.new(message_format, transport_mechanism)
      listener = Listener.new(port, protocol)
      with_listener(listener)
    end
    
    def remote(message_format, transport_mechanism, remote_host, remote_port)
      protocol = Protocol.new(message_format, transport_mechanism)
      endpoint = RemoteEndpoint.new(remote_host, remote_port, protocol)
      using_endpoint(endpoint)
    end

    # proxy start/stop to listener
    def start; @listener.start; end
    def stop; @listener.stop;   end
    
    def handle(request)
      @remote_endpoint.transmit(request)
    end
    
  end
end