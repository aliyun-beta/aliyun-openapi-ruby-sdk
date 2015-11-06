require File.expand_path('../../../test_helper', __FILE__)

module Aliyun::Openapi
  class CoreTest < Minitest::Test

    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
      # Do nothing
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def teardown
      # Do nothing
    end

    #  test configuration
    def test_configuration
      Aliyun::Openapi.configure do |config|
        config.server_address = 'ecs.aliyuncs.com'
        config.ssl_required =  true
        config.token = 'AXDS'
      end
      assert !Aliyun::Openapi.config.end_points.nil?

      #test necessary types
      Aliyun::Openapi.config.end_points.each do |k,v|
        assert_kind_of Array, v[:region_ids]
        assert !v[:region_ids].empty?
        assert_kind_of Hash, v[:products]
      end

      assert_equal 'ecs.aliyuncs.com', Aliyun::Openapi.config.server_address
      assert Aliyun::Openapi.config.ssl_required
      assert_equal 'AXDS', Aliyun::Openapi.config.token
    end
  end
end
