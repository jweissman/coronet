module Coronet
  module MessageFormat
    class XmlMessageFormat < Base
      # transform xml string to hash
      def unpack(xml_str)
       # puts "--- xml message format attempting to unpack: #{xml_str}"
        unpacked = XmlSimple.xml_in(xml_str, forcearray: false, keeproot: true)
        unpacked = unpacked['opt'] if unpacked.has_key? 'opt'
       # puts "--- unpacked: #{unpacked}"
        unpacked
      end
      
      # transform hash to xml string
      def pack(hash, root='opt')
        XmlSimple.xml_out(hash, noattr: true, rootname: root).strip!
      end
    end
  end
end