# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/sudo/version'

Gem::Specification.new do |gem|
  gem.name          = 'cinch-sudo'
  gem.version       = Cinch::Plugins::Sudo::VERSION
  gem.authors       = ['Paul Visscher', 'Brian Haberer']
  gem.email         = ['bhaberer@gmail.com']
  gem.description   = %q{Cinch Plugin to report usage of Sudo to the channel}
  gem.summary       = %q{Cinch Plugin for monitoring Sudo}
  gem.homepage      = 'https://github.com/canonical-hackers/cinch-sudo'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec-given'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'cinch-test'

  gem.add_dependency 'cinch', '~> 2.0.12'
  gem.add_dependency 'file-tail'
end
