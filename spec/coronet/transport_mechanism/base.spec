require 'gserver'

require 'contractual'

require 'coronet/transport_mechanism/base'
require 'coronet/transport_mechanism/length_prefixed_tcp_transport'

require 'coronet/support/echo_server'

module Coronet
  module TransportMechanism
    describe Base, "encapsulates transport-layer functionality" do
      it "supports interaction with remote services" do
        echo = Support::EchoServer.new(12345)
        tcp  = LengthPrefixedTcpTransport.new
        
        echo.start
        io   = tcp.open('localhost', 12345)
        msg = "data" *1250
        # p msg
        tcp.transmit(msg, io).should == msg
        echo.stop
      end   
    end
  end
end