if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start  do
    add_group "Core", ["core", "openapi.rb"]
    add_group "Generated", "/generated/lib"
    add_filter "test/"
  end
  # puts "required simplecov"
end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/openapi'
require 'pry'
require 'minitest/autorun'
require 'rainbow'
require "mocha/mini_test"



$LOAD_PATH.unshift File.expand_path('../../generated/lib', __FILE__)
#
Dir[File.expand_path('../../generated/lib/aliyun/openapi/*.rb', __FILE__)].each do |path|
  require path.gsub(/^.*generated\/lib\/(.*)\.rb/, '\1')
end

Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-05-26').create_instance.end_point do |end_point|
  end_point.param :param1, :int, false
  end_point.param :param2, :string, true
end

# puts Aliyun::Openapi::Core::ApiDSL.root.to_s(level: 0)

class ApiTest < Minitest::Test
  def setup
    Aliyun::Openapi::Core::EndPoint.any_instance.stubs(:exec_call).returns(Aliyun::Openapi::Core::Result.new)
  end

  def teardown
    # do nothing
  end
end