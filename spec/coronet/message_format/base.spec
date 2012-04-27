require 'contractual'
require 'xmlsimple'

require 'coronet/message_format/base'
require 'coronet/message_format/xml_message_format'
require 'coronet/message_format/yaml_message_format'

module Coronet
  module MessageFormat
    describe Base, "should describe structured message formats" do
    
      before :each do
        @yml, @xml = YamlMessageFormat.new, XmlMessageFormat.new
        @yml_data = "---\nhello: world\n"
        @xml_data = "<hello>world</hello>"
      end
    
      it "should handle yml" do
        @yml.unpack(@yml_data).should == { 'hello' => 'world' }
        @yml.pack(@yml.unpack(@yml_data)).should == @yml_data
      end
    
      it "should handle xml" do
        @xml.unpack(@xml_data).should == { 'hello' => 'world' }
        @xml.pack(@xml.unpack(@xml_data), nil).should == @xml_data
      end

      it "should handle transforming yml to xml (and vice versa)" do
        @xml.unpack(@xml_data).should == @yml.unpack(@yml_data)
        @xml.pack(@yml.unpack(@yml_data), nil).should == @xml_data
        @yml.pack(@xml.unpack(@xml_data)).should == @yml_data
      end
    end
  end
end