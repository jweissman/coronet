module Coronet
  module MessageFormat
    class XmlMessageFormat < Base
      # transform xml string to hash
      def unpack(xml_str)
        XmlSimple.xml_in(xml_str, forcearray: false, keeproot: true)
      end
      
      # transform hash to xml string
      def pack(hash)
        XmlSimple.xml_out(hash, noattr: true, rootname: nil).strip!
      end
    end
  end
end