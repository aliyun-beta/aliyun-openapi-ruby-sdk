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
        config.access_key_id = '1'
        config.access_key_secret = '2'
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
      assert_equal '1', Aliyun::Openapi.config.access_key_id
      assert_equal '2', Aliyun::Openapi.config.access_key_secret
    end

    def test_look_up_server
      Aliyun::Openapi.configure do |config|
        config.ssl_required =  true
      end
      # assert_equal 'r-kvstore-cn-hangzhou.aliyuncs.com', Aliyun::Openapi.config.look_up_server('r_kvstore')
      assert_equal 'oss-admin.aliyuncs.com', Aliyun::Openapi.config.look_up_server('ossadmin')
      assert_equal 'oss-admin.aliyuncs.com', Aliyun::Openapi.config.look_up_server('ossadmin', 'cn-hangzhou')
    end
  end
end
