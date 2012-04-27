module Coronet
  module TransportMechanism
    class Base
      include Contractual::Interface
    
      must :open, :host, :port
      must :write, :data, :io
      must :read, :io
      must :close, :io
    
      def transmit(data, io)
        write(data, io)
        response = read(io)
        close(io)
        response
      end
    end
  end
end