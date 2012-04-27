module Coronet
  class Mediator
    
    # proxy start/stop to dedicated listener
    def self.start_listener; @@listener.start; end
    def self.stop_listener; @@listener.stop;   end
    def self.listen(&block)
      unless block_given?
        start_listener 
      else
        start_listener
        block.call
        stop_listener
      end
    end
    
    def self.handle(request)
      if defined? @@preprocess_handler
        @@preprocess_handler.call(request) 
      end
      
      response = @@remote_endpoint.transmit(request)
      
      if defined? @@postprocess_handler
        @@postprocess_handler.call(request, response) 
      end
      
      return response
    end
    
    # DSL support
    class << self
      # callbacks
      def preprocess(&block);  puts "--- pre-handler assigned";  @@preprocess_handler  = block; end
      def postprocess(&block); puts "--- post-handler assigned"; @@postprocess_handler = block; end
      
      # mediation config
      def with_listener(listener)
        @@listener = listener
        @@listener.uses_mediator_class(self)        
      end
      
      def listener(port, proto)
        with_listener(Listener.new(port, proto))
      end
      
      def for_endpoint(remote_endpoint)
        @@remote_endpoint = remote_endpoint
      end
      
      def endpoint(host, port, proto)
        for_endpoint(RemoteEndpoint.new(host, port, proto))
      end
      
      # message formats
      def yaml; MessageFormat::YamlMessageFormat.new; end
      def xml;  MessageFormat::XmlMessageFormat.new;  end
      
      # xport
      def length_prefixed_tcp; TransportMechanism::LengthPrefixedTcpTransport.new; end
      
      # protocol
      def protocol(format, transport); Protocol.new(format, transport); end
      
      def yaml_via_tcp; protocol(yaml, length_prefixed_tcp); end
      def xml_via_tcp; protocol(xml, length_prefixed_tcp); end
    end
    
  end
end