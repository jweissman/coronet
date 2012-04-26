module Coronet
  class TransformationRule
    attr_accessor :in, :out
    
    def initialize(incoming, outgoing)
      @in = incoming
      @out = outgoing
    end
    
    def apply(message)
      @in.transform(message, @out)
    end
    
    def inverse; TransformationRule.new(@out, @in); end
  end
end