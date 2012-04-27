require 'gserver'

require 'contractual'
require 'xmlsimple'

require 'coronet/support/request_reply_server'

require 'coronet/message_format/base'
require 'coronet/message_format/xml_message_format'
require 'coronet/message_format/yaml_message_format'

require 'coronet/transport_mechanism/base'
require 'coronet/transport_mechanism/length_prefixed_tcp_transport'

require 'coronet/protocol'
require 'coronet/listener'
require 'coronet/remote_endpoint'

require 'coronet/mediator'

module Coronet
  
  include TransportMechanism
  include MessageFormat
  include Support
  
  $mediator_port, $host_port = 10000, 10001
  
  describe Mediator, "mediates between clients and servers" do
    
    before :each do
      @xml_over_tcp = Protocol.new(XmlMessageFormat.new, LengthPrefixedTcpTransport.new)
      
      @request = { 'hello' => 'server' }      
      @expected_response = { 'hello' => 'client' }
    end
    
    # after :each do
    # end
    
    it "adapts protocols" do
      
      class SimpleMediator < Mediator
        with_listener Listener.new($mediator_port, 
                          Protocol.new(
                              MessageFormat::XmlMessageFormat.new, 
                              TransportMechanism::LengthPrefixedTcpTransport.new))

        for_endpoint RemoteEndpoint.new('localhost', $host_port, 
                        Protocol.new(
                          MessageFormat::YamlMessageFormat.new, 
                          TransportMechanism::LengthPrefixedTcpTransport.new))
      end
      
      host = RequestReplyServer.new($host_port, YamlMessageFormat.new)        
      host.start
      SimpleMediator.listen do

        @xml_over_tcp.transmit(@request, 'localhost', $mediator_port).should == @expected_response
      end
      host.stop
    end
    
    it "supports a simple DSL" do
      
      class SimpleMediatorUsingDSL < Mediator
        listener $mediator_port, xml_via_tcp
        endpoint 'localhost', $host_port, yaml_via_tcp
      end
      
      host = RequestReplyServer.new($host_port, YamlMessageFormat.new)
      host.start
      
      SimpleMediatorUsingDSL.listen do
        @xml_over_tcp.transmit(@request, 'localhost', $mediator_port).should == @expected_response        
      end
      host.stop      
    end
    
    it "handles callbacks" do
      

      $preprocess_invoked, $postprocess_invoked = false, false
      class SimpleMediatorWithCallbacks < SimpleMediatorUsingDSL
        preprocess  do |req|  
          $preprocess_invoked = true
        end

        postprocess do |req, rsp| 
          $postprocess_invoked = true
        end
      end
      
      host = RequestReplyServer.new($host_port, YamlMessageFormat.new)
      host.start
      SimpleMediatorWithCallbacks.listen do
        @xml_over_tcp.transmit(@request, 'localhost', $mediator_port).should == @expected_response
      end
      host.stop
      $preprocess_invoked.should == true
      $postprocess_invoked.should == true
    end
    
    it "supports concurrent request handling" do
      
      class SimpleMediatorWithLogging < SimpleMediatorUsingDSL
        postprocess do |req, rsp| 
          # puts "--- request #{req} got response #{rsp}"
        end
      end

      host = RequestReplyServer.new($host_port, YamlMessageFormat.new)
      host.start
      SimpleMediatorWithLogging.listen do

        
        client_count = 2
        message_count = 3
        
        clients = []
        (1..client_count).each do |n|
          client = Thread.new do
            message_count.times do |index|
              msg = { 'hello' => 'server', 'client' => n, 'index' => index }
              xml_over_tcp = Protocol.new(XmlMessageFormat.new, LengthPrefixedTcpTransport.new)
              # puts "--- client #{n} about to transmit message #{msg}"
              response = xml_over_tcp.transmit(msg, 'localhost', $mediator_port)
              # puts "--- client #{n} got response #{response}"
              response['hello'].should == 'client'
              response['client'].to_i.should == n
              response['index'].to_i.should == index
              sleep 0.1
            end
          end
          clients << client
          
        end
        clients.each { |client| client.join }
      end
      host.stop
    end
  end
end