module Coronet
  module MessageFormat
    class Base
    
      include Contractual::Interface
    
      must :pack, :message
      must :unpack, :message
    
      def transform(message, outgoing_format)
        unpacked = unpack(message)
        outgoing_format.pack(unpacked)
      end
    
    end
  end
end