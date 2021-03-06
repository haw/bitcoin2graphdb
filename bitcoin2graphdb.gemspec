# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitcoin2graphdb/version'

Gem::Specification.new do |spec|
  spec.name          = "bitcoin2graphdb"
  spec.version       = Bitcoin2Graphdb::VERSION
  spec.authors       = ["azuchi"]
  spec.email         = ["azuchi@haw.co.jp"]

  spec.summary       = %q{A tool for import Bitcoin blockchain data into neo4j database.}
  spec.description   = %q{A tool for import Bitcoin blockchain data into neo4j database.}
  spec.homepage      = "https://github.com/haw-itn/bitcoin2graphdb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "openassets-ruby", ">= 0.6.5"
  spec.add_runtime_dependency "daemon-spawn"
  spec.add_runtime_dependency "neo4j", "~>9.4.0"
  spec.add_runtime_dependency "neo4j-rake_tasks"
  spec.add_runtime_dependency "activesupport", ">= 4.0.2"
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "octorelease"

end
