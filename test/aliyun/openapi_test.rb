require File.expand_path('../../test_helper', __FILE__)

class Aliyun::OpenapiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Aliyun::Openapi::VERSION
  end

  def test_get_client
    Aliyun::Openapi.configure do |config|
      config.ssl_required = true
      config.format = :xml
      config.access_key_id = 'id'
      config.access_key_secret = 'sec'
    end
    stub_request(:any, /.*\.aliyuncs\.com/)
    assert_equal :ecs, Aliyun::Openapi::Client.ecs(version: '2014-05-26').create_mock_instance.product
    Aliyun::Openapi::Client.ecs(version: '2014-05-26').create_mock_instance(param2: 'abc') do |reponse|
    end
  end
end
