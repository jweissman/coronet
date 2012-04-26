# Coronet

Coronet is a dynamically-reconfigurable message-mediation (transformation) server appliance.

(A 'coronet' is a small, simple crown -- possibly made with grass or leaves.)

## Installation

Add this line to your application's Gemfile:

    gem 'coronet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coronet

## Usage

Coronet requires the definition of message formats, transports, service entry/end-points and mediation rules. Once these are defined, you can construct 'service layers' which automatically mediate messages.

### Message Formats

*Message formats* currently just have to implement 'pack' and 'unpack' functions.

Currently provided are a simple Yaml and XML message format specification.

Eventually there should be mappers which can transform hash keys.

	class MyCustomMessageFormat < Coronet::MessageFormat
		def pack(hash)
			# pack logic goes here
			# return binary data/string/whatever
		end
	
		def unpack(data)
			# unpack business logic
			# return hash of element names => values
		end
	end


### Transformation Rules

*Transformation rules* adapt one message format to another. Eventually this may support
manipulation/mapping of key names.

### Transport Mechanisms

*Transport mechanisms* encapsulate functional requirements for message transport to 
remote services.

Currently, transport mechanisms have to implement 'open', 'read', 'write(data)' 
and 'close' methods. There is a simple length-prefixed TCP implementation provided.
I'd like to eventually support SSL (over TCP) and HTTP(S).

### Protocols

A *protocol* combines a particular transport mechanism and a message format. 

### Listeners, Remote Endpoints and Mediators

*Listeners* are entrypoints into the mediating framework, and need to specify
their message format, transport mechanism, and local listening port.

*Remote endpoints* are foreign service interfaces, which need to specify
the format and transport like a listener, but also need to specify the remote
address and port of the target host.

*Mediators* link these together into a concrete process resulting in requests 
being transformed, transported to remote endpoints, the responses gathered, 
transformation rules applied, and the initiating actor (client) being sent 
the transformed response.

## Example

The following simple example should start the Coronet engine on localhost:10000,
listening for XML requests via TCP, and mediate the requests to localhost:10001
in YML over TCP.

	require 'coronet'
	
	tcp = Coronet::TransportMechanism::LengthPrefixedTcpTransport.new
	xml = Coronet::MessageFormat::XmlMessageFormat.new
	yml = Coronet::MessageFormat::YamlMessageFormat.new

	mediator = Coronet::Mediator.new do
	  local  xml, tcp, 10000
	  remote yml, tcp, 'localhost', 10001        
	end

	mediator.start




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
