# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mq_cron/version'

Gem::Specification.new do |spec|
  spec.name          = "mq_cron"
  spec.version       = MqCron::VERSION
  spec.authors       = ["Marius Rieder"]
  spec.email         = ["marius.rieder@durchmesser.ch"]
  spec.summary       = %q{Message Queue Cron - Run commands ion response to messages}
  spec.description   = %q{Message Queue Cron - Run commands ion response to messages}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'bunny'
  spec.add_dependency 'daemons'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'md2man', '~> 4.0'
end
