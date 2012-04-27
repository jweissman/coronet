require 'coronet'

tcp = Coronet::TransportMechanism::LengthPrefixedTcpTransport.new
xml = Coronet::MessageFormat::XmlMessageFormat.new
yml = Coronet::MessageFormat::YamlMessageFormat.new


# 
# mediator = Coronet::Mediator.new do
#   local  xml, tcp, 10000
#   remote yml, tcp, 'localhost', 10001        
# end
# 
# mediator.start