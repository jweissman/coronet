module Coronet
  module TransportMechanism
    #
    #
    #  Supports length-prefixed TCP transport.
    #
    #
    class LengthPrefixedTcpTransport < Base
      attr_accessor :tcp_socket
      
      def open(host, port)
        TCPSocket.open(host, port)
      end
      
      def read(io)
        length_header = io.read(2)
        p length_header
        length = length_header.unpack("S").first
        io.read(length)
      end
      
      def write(data, io)
        length = data.size
        prefix = to_byte_array(length).pack("S")

        io.print(prefix)
        io.print(data)
      end
      
      def close(io)
        io.close
      end
      
      private 
        def to_byte_array(num)
          result = Array.new
          begin
            result << (num & 0xff)
            num >>= 8
          end until (num == 0 || num == -1) && (result.last[7] == num[7])
          result.reverse
        end
      
    end
  end
end