require 'contractual'
require 'xmlsimple'
require 'psych'

require 'coronet/message_format/base'
require 'coronet/message_format/xml_message_format'
require 'coronet/message_format/yaml_message_format'

require 'coronet/transformation_rule'

module Coronet
  describe TransformationRule, "transforms messages into other formats" do
    before :each do
      @yml, @xml = MessageFormat::YamlMessageFormat.new, MessageFormat::XmlMessageFormat.new
      @yml_data = "---\nhello: world\n"
      @xml_data = "<hello>world</hello>"
    end
    
    it "transforms xml to yml" do
      rule = TransformationRule.new(@xml, @yml)
      rule.apply(@xml_data).should == @yml_data
    end
    
    it "transforms yml to xml" do
      rule = TransformationRule.new(@yml, @xml)
      rule.apply(@yml_data).should == @xml_data
    end    
  end
end