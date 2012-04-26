require 'gserver'

require 'contractual'
require 'xmlsimple'

require 'coronet/message_format/base'
require 'coronet/message_format/xml_message_format'

require 'coronet/transport_mechanism/base'
require 'coronet/transport_mechanism/length_prefixed_tcp_transport'

require 'coronet/protocol'
require 'coronet/remote_endpoint'

require 'coronet/support/echo_server'

module Coronet
  
  describe RemoteEndpoint, "conjoins a concrete endpoint, message format and transport-layer functionality" do
    it "supports xml-via-tcp interaction with remote interfaces" do
      
      tcp = TransportMechanism::LengthPrefixedTcpTransport.new
      xml = MessageFormat::XmlMessageFormat.new
      xml_via_tcp = Protocol.new(xml, tcp)
      echo_server_endpoint = RemoteEndpoint.new('localhost', 12345, xml_via_tcp)
      
      msg = { 'hello' => 'world' }
      
      echo = Support::EchoServer.new
      echo.start
      echo_server_endpoint.transmit(msg).should == msg
      echo.stop
    end
  end
  
end