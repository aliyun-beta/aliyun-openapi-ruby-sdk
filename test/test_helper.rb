if ENV["TESTLOCAL"]
  require 'simplecov'
  SimpleCov.start  do
    add_group "Core", ["core", "openapi.rb", 'faraday']
    add_group "Generated", "/generated/lib"
    add_filter "test/"
  end
else
  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/openapi'
require 'minitest/autorun'
require 'rainbow'
require "mocha/mini_test"
require 'webmock/minitest'
require 'timecop'


require 'coveralls'
Coveralls.wear!


$LOAD_PATH.unshift File.expand_path('../../generated/lib', __FILE__)

require 'aliyun/openapi/all'
#
# Dir[File.expand_path('../../generated/lib/aliyun/openapi/*.rb', __FILE__)].each do |path|
#   require path.gsub(/^.*generated\/lib\/(.*)\.rb/, '\1')
# end

Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-05-26').create_mock_instance.end_point do |end_point|
  end_point.param :param1, :integer, false
  end_point.param :param2, :string, true
end

Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-05-26').create_mock_project.end_point do |end_point|
  end_point.param :'ProjectName', :Integer, false, 'tagPosition' => 'Path'
  end_point.param :'Alert', :String, true, 'tagPosition' => 'Body'
  end_point.param :'Type', :String, true, 'tagPosition' => 'Query'
  end_point.pattern =  "/projects/[ProjectName]/alerts"
  end_point.methods = ['POST']
end

# puts Aliyun::Openapi::Core::ApiDSL.root.to_s(level: 0)

class ApiTest < Minitest::Test
  def setup
    Aliyun::Openapi.configure do |config|
      config.ssl_required = true
      config.format = :json
    end
    Aliyun::Openapi::Core::EndPoint.any_instance.stubs(:exec_call).returns(Faraday::Response.new)
  end

  def teardown
    # do nothing
  end
end