module Coronet
  module Support
    
    class RequestReplyServer < GServer
      def initialize(port=12345, format=MessageFormat::YamlMessageFormat.new, *args)
        super(port, *args)
        @tcp = TransportMechanism::LengthPrefixedTcpTransport.new
        @format = format
        @count = 0
      end
      
      def serve(io)
        packed_request = @tcp.read(io)
        request = @format.unpack(packed_request)
        response = handle(request)
        packed_response = @format.pack(response)
        @tcp.write(packed_response, io)
      end
      
      def handle(request)
        @count += 1
        # puts "--- mock host handling request #{@count}: #{request}"
        request['hello'] = 'client' if request.has_key? 'hello'
        request
      end
    end

  end
end