module Coronet
  module MessageFormat
    class YamlMessageFormat < Base
      
      # transform yml string to hash
      def unpack(yml_str)
        Psych.load(yml_str)
        # YAML.load(yml_str)
      end
      
      # transform hash to yml string
      def pack(hash)
        yml_out = Psych.dump(hash) #.strip!
      end
      
    end
  end
end