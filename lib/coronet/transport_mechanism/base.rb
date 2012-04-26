module Coronet
  module TransportMechanism
    class Base
      include Contractual::Interface
    
      must :open, :host, :port
      must :write, :data
      must :read
      must :close
      
      # attr_accessor :host, :port
      # attr_accessor :io
      
      # def initialize #(host, port)
        # @host = host
        # @port = port
      # end
    
      def transmit(data, io)
        # io = open(host, port)
        write(data, io)
        response = read(io)
        close(io)
        
        response
      end
    end
  end
end