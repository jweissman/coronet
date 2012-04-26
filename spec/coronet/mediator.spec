require 'gserver'

require 'contractual'
require 'xmlsimple'

require 'coronet/support/echo_server'

require 'coronet/message_format/base'
require 'coronet/message_format/xml_message_format'
require 'coronet/message_format/yaml_message_format'

require 'coronet/transport_mechanism/base'
require 'coronet/transport_mechanism/length_prefixed_tcp_transport'

require 'coronet/protocol'
require 'coronet/listener'
require 'coronet/transformation_rule'
require 'coronet/remote_endpoint'

require 'coronet/mediator'

module Coronet
  
  describe Mediator, "mediates between clients and servers" do
    # it "mediates between client and server"
    # it "transforms message formats"
    it "adapts transport mechanisms and protocols" do
      tcp = TransportMechanism::LengthPrefixedTcpTransport.new
      
      xml = MessageFormat::XmlMessageFormat.new
      yml = MessageFormat::YamlMessageFormat.new
      
      xml_via_tcp = Protocol.new(xml, tcp)
      yml_via_tcp = Protocol.new(yml, tcp)
      
      xml_to_yml = TransformationRule.new(xml, yml)
      
      listener = Listener.new(10000, xml_via_tcp)
      
      echo_server = Support::EchoServer.new(10001)
      echo_server_endpoint = RemoteEndpoint.new('localhost', 10001, yml_via_tcp)
      
      mediator = Mediator.new listener: listener, endpoint: echo_server_endpoint # , xml_to_yml)
      
      echo_server.start
      mediator.start
      
      msg = { 'hello' => 'world' }
      xml_via_tcp.transmit(msg, 'localhost', 10000).should == msg
      
      mediator.stop
      echo_server.stop
    end
    
    it "supports a basic DSL" do
      
      tcp = TransportMechanism::LengthPrefixedTcpTransport.new
      xml = MessageFormat::XmlMessageFormat.new
      yml = MessageFormat::YamlMessageFormat.new
      
      mediator = Mediator.new do
        local  xml, tcp, 10000
        remote yml, tcp, 'localhost', 10001        
      end
      
      echo_server = Support::EchoServer.new(10001)
      
      msg = { 'hello' => 'world' }
      xml_via_tcp = Protocol.new(xml, tcp)
      
      mediator.start
      echo_server.start
      
      xml_via_tcp.transmit(msg, 'localhost', 10000).should == msg
      
      echo_server.stop
      mediator.stop
      
    end
  end
end