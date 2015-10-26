# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliyun/version'

Gem::Specification.new do |spec|
  spec.name          = "aliyun"
  spec.version       = Aliyun::VERSION
  spec.authors       = ["shruby"]
  spec.email         = ["shruby@github"]
  spec.summary       = %q{Aliyun OpenAPI}
  spec.description   = %q{Aliyun OpenAPI}
  spec.homepage      = "https://github.com/shruby/aliyun-openapi"
  spec.license       = "Apache"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
