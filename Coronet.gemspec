# -*- encoding: utf-8 -*-
require File.expand_path('../lib/coronet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joseph Weissman"]
  gem.email         = ["jweissman1986@gmail.com"]
  gem.description   = %q{Coronet is a simple protocol adaption framework}
  gem.summary       = %q{Coronet is an extensible message-mediation server appliance.}
  # gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "coronet"
  gem.require_paths = ["lib"]
  gem.version       = Coronet::VERSION
end
