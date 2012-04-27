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

Coronet requires the definition of message formats, transports, service entry/end-points and mediation patterns. Once these are defined, it is straightforward to construct a message-transformation and mediation service using Coronet.

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

## Examples

Specifying explicit constructors for clarity, here is perhaps the most verbose
way to setup a mediation framework with Coronet. The example below starts a mediation service
listening on $mediation_port for XML messages over binary-length-prefixed TCP,
transforms these messages to YAML, and mediates them to a remote host listening
at $host_port.

	class SimpleMediator < Mediator
	  with_listener Listener.new($mediator_port, 
	                    Protocol.new(
	                        MessageFormat::XmlMessageFormat.new, 
	                        TransportMechanism::LengthPrefixedTcpTransport.new))
                        
	  for_endpoint RemoteEndpoint.new('localhost', $host_port, 
	                  Protocol.new(
	                    MessageFormat::YamlMessageFormat.new, 
	                    TransportMechanism::LengthPrefixedTcpTransport.new))
	end
	
	# to launch the service, just call the class method 'start_listening'
	SimpleMediator.start_listening
	
The following example makes fuller use of the built-in DSL, and is accordingly
much less verbose. The same mediation service is created:

	class SimpleMediatorUsingDSL < Mediator
	  listener $mediator_port, xml_via_tcp
	  endpoint 'localhost', $host_port, yaml_via_tcp
	end
	
You can provide custom processing instructions to the mediation framework. For
instance, you might want to log every request/response pattern to the database;
or simply keep track of how many messages you've processed. Here is an example
of utilizing these callbacks:

	class SimpleMediatorWithCallbacks < SimpleMediatorUsingDSL
	  preprocess  do |req|
		# do something with request object 'req'
	  end
	
	  postprocess do |req, rsp| 
		# do something with request and response objects 'req' and 'rsp'
	  end
	end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
