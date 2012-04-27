require 'gserver'

require 'contractual'
require 'xmlsimple'

require 'coronet/message_format/base'
require 'coronet/message_format/xml_message_format'

require 'coronet/transport_mechanism/base'
require 'coronet/transport_mechanism/length_prefixed_tcp_transport'

require 'coronet/protocol'
require 'coronet/listener'

module Coronet
  describe Listener, "encapsulates an entrypoint into the mediating framework" do
    
    module Echo
      def self.handle(request)
        request
      end
    end
    
    it "serves external requests and provides a callback for processing" do
      
      tcp = TransportMechanism::LengthPrefixedTcpTransport.new
      xml = MessageFormat::XmlMessageFormat.new
      xml_via_tcp = Protocol.new(xml, tcp)
      
      echo_listener = Listener.new(12345, xml_via_tcp)
      echo_listener.uses_mediator_class(Echo)
      echo_listener.start
      
      msg = { 'hello' => 'world' }
      xml_via_tcp.transmit(msg, 'localhost', 12345).should == msg
      
      echo_listener.stop
    end
  end
end