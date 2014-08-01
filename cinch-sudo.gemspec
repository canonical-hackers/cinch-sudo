# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/sudo/version'

Gem::Specification.new do |gem|
  gem.name          = 'cinch-sudo'
  gem.version       = Cinch::Plugins::Sudo::VERSION
  gem.authors       = ['Paul Visscher', 'Brian Haberer']
  gem.email         = ['bhaberer@gmail.com']
  gem.description   = %q(Cinch Plugin to report usage of Sudo to the channel)
  gem.summary       = %q(Cinch Plugin for monitoring Sudo)
  gem.homepage      = 'https://github.com/canonical-hackers/cinch-sudo'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'coveralls', '~> 0.7'
  gem.add_development_dependency 'cinch-test', '~> 0.1', '>= 0.1.0'
  gem.add_dependency 'cinch', '~> 2'
  gem.add_dependency 'file-tail'
end
