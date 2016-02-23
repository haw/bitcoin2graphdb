# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitcoin2graphdb/version'

Gem::Specification.new do |spec|
  spec.name          = "bitcoin2graphdb"
  spec.version       = Bitcoin2graphdb::VERSION
  spec.authors       = ["azuchi"]
  spec.email         = ["azuchi@haw.co.jp"]

  spec.summary       = %q{This is a migration tool to import Blockchain data to neo4j}
  spec.description   = %q{This is a migration tool to import Blockchain data to neo4j}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "openassets-ruby", "~> 0.3.7"
  spec.add_runtime_dependency "daemon-spawn"
  spec.add_runtime_dependency "neography"
  spec.add_runtime_dependency "activesupport", "~> 4.0.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
