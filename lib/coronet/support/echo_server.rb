module Coronet
  module Support
    
    class EchoServer < GServer
      def initialize(port=12345, *args)
        super(port, *args)
        @tcp = TransportMechanism::LengthPrefixedTcpTransport.new
      end
      def serve(io)
        @tcp.write(@tcp.read(io), io)
      end
    end

  end
end