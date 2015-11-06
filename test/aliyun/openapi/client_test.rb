require File.expand_path('../../../test_helper', __FILE__)

require 'time'

module Aliyun::Openapi
  class ClientTest < Minitest::Test

    def setup
      Aliyun::Openapi.configure do |config|
        config.server_address = 'ecs.aliyuncs.com'
        config.ssl_required = true
        config.access_key_id = 'testid'
        config.access_key_secret = 'testsecret'
      end
      stub_request(:any, /.*\.aliyuncs\.com/)
    end

    def test_mock
      SecureRandom.stubs(:hex).returns('NwDAxvLU6tFE0DVb')
      Timecop.freeze(Time.iso8601('2012-12-26T10:33:56Z')) do
        c = Core::Client.connection(:end_point => 'http://ecs.aliyuncs.com/?Format=XML&AccessKeyId=testid&Action=DescribeRegions&RegionId=region1&SignatureNonce=NwDAxvLU6tFE0DVb&Version=2014-05-26')
        p c.get('')
      end

      p Net::HTTP.get('xxx.aliyuncs.com', '/')
    end
  end
end
