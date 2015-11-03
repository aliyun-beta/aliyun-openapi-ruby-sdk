# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliyun/openapi/version'

Gem::Specification.new do |spec|
  spec.name          = "aliyun-openapi"
  spec.version       = Aliyun::Openapi::VERSION
  spec.authors       = ["Shanghai Ruby User Group"]
  spec.email         = ["shanghairuby@gmail.com"]

  spec.summary       = %q{Aliyun Open API}
  spec.description   = %q{Aliyun Open API Ruby Interface}
  spec.homepage      = "https://github.com/shruby/aliyun-openapi"
  spec.license       = "Apache 2"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|templates|tasks)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '0.9.2'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10.0"
  spec.add_development_dependency "rainbow", "~> 2.0"
  spec.add_development_dependency "mocha", "~> 1.1"
  spec.add_development_dependency "minitest"
end
