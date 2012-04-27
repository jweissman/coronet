require 'gserver'

require 'contractual'
require 'xmlsimple'

require 'coronet/message_format/base'
require 'coronet/message_format/xml_message_format'

require 'coronet/transport_mechanism/base'
require 'coronet/transport_mechanism/length_prefixed_tcp_transport'
require 'coronet/support/echo_server'

require 'coronet/protocol'

module Coronet
  describe Protocol, "conjoins a message format and transport-layer functionality" do
    it "supports xml-via-tcp interaction with remote interfaces" do 
      echo = Support::EchoServer.new
      echo.start
      
      tcp = TransportMechanism::LengthPrefixedTcpTransport.new
      xml = MessageFormat::XmlMessageFormat.new
      xml_via_tcp = Protocol.new(xml, tcp)
      
      msg = { 'hello' => 'world', 'whats' => 'up' }
      xml_via_tcp.transmit(msg, 'localhost', 12345).should == msg
      
      echo.stop
    end
  end
end