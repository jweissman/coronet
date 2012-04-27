module Coronet
  module TransportMechanism
    #
    #
    #  Supports length-prefixed TCP transport.
    #
    #
    class LengthPrefixedTcpTransport < Base
      attr_accessor :tcp_socket
      
      # n.b., for four bytes, can just use 4/'N'
      LENGTH_HEADER_BYTES = 2
      LENGTH_HEADER_STORAGE_CLASS = "n"
      
      def open(host, port); TCPSocket.open(host, port); end
      
      def read(io)
        length_header = io.read(LENGTH_HEADER_BYTES)
        # p length_header
        length = length_header.unpack(LENGTH_HEADER_STORAGE_CLASS).first
        # puts "--- TCP READ #{length}"
        
        io.read(length)
      end
      
      def write(data, io)
        # puts "--- TCP WRITE #{data}"
        length = data.size
        prefix = [length].pack(LENGTH_HEADER_STORAGE_CLASS)
        io.print(prefix)
        io.print(data)
      end
      
      def close(io)
        io.close
      end
    end
  end
end