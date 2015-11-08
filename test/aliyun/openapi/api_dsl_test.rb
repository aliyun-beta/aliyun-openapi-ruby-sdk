require File.expand_path('../../../test_helper', __FILE__)
module Aliyun::Openapi
  class ApiDSLTest < Minitest::Test


    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
      Aliyun::Openapi.configure do |config|
        config.server_address = 'ecs.aliyuncs.com'
        config.ssl_required = true
        config.access_key_id = 'testid'
        config.access_key_secret = 'testsecret'
      end
      stub_request(:any, /.*\.aliyuncs\.com/)
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def teardown
      # Do nothing
    end

    # test dsl
    def test_define_client_by_dsl

      assert_raises(RuntimeError) do
        Core::ApiDSL.client.xxx(version:'2014-05-26').create_mock_instance(param1: 1, param2: 'abc') do |response|
        end
      end

      assert_raises(RuntimeError) do
        Core::ApiDSL.client.ecs(version:'2014-05-27').create_mock_instance(param1: 1, param2: 'abc') do |response|
        end
      end


      Core::ApiDSL.client.ecs(version:'2014-05-26').create_mock_instance(param1: 1, param2: 'abc') do |response|
        assert response.respond_to?(:body)
        # p response.body
        # assert response.respond_to?(:parsed_result)
      end

      Core::ApiDSL.client.ecs(version:'2014-05-26').create_mock_instance(param1: 1, param2: 'abc') do |response|

      end

      # puts Core::ApiDSL.root.to_s(level: 0)
    end

    def test_invalid_params
      assert_raises(InvalidParamsError) do
        Core::ApiDSL.client.ecs(version:'2014-05-26').create_mock_instance(param1: 1) do |response|
          assert response.respond_to?(:body)
          # assert response.respond_to?(:parsed_result)
        end
      end
    end

    def test_end_point
      assert_equal :ecs, Core::ApiDSL.client.ecs(version:'2014-05-26').create_mock_instance.product
      assert_equal :ecs, Core::ApiDSL.client.ecs(version:'2014-05-26').product.name
      assert_equal :'2014-05-26', Core::ApiDSL.client.ecs(version:'2014-05-26').version.name
    end

    def test_build_url
      assert_kind_of Core::EndPoint, Core::ApiDSL.client.ecs(version:'2014-05-26').create_mock_project
      assert_equal '/projects/1/alerts?Action=CreateMockProject&Type=Integer&Version=2014-05-26', Core::ApiDSL.client.ecs(version:'2014-05-26').create_mock_project.build_url('ProjectName': 1, 'Alert': 'abcdefg', 'Type': 'Integer')
    end

    def test_endpoints_with_different_versions
      Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-05-26').create_mock_endpoint.end_point do |end_point|
        end_point.param :'ProjectName', :Integer, true, 'tagPosition' => 'Path'
        end_point.param :'Alert', :String, true, 'tagPosition' => 'Body'
        end_point.param :'Type', :String, false, 'tagPosition' => 'Query'
        end_point.pattern =  "/projects/[ProjectName]/alerts"
        end_point.methods = ['POST']
      end

      Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-06-26').create_mock_endpoint.end_point do |end_point|
        end_point.param :'ProjectName', :Integer, true, 'tagPosition' => 'Path'
        end_point.param :'Alert', :String, true, 'tagPosition' => 'Body'
        end_point.param :'Type', :String, false, 'tagPosition' => 'Query'
        end_point.pattern =  "/projects/[ProjectName]/alerts"
        end_point.methods = ['POST']
      end

      Core::ApiDSL.client.ecs(version:'2014-05-26').create_mock_endpoint(ProjectName: 1, Alert: 'abc') do |response|
        assert response.respond_to?(:body)
      end
      Core::ApiDSL.client.ecs(version:'2014-06-26').create_mock_endpoint(ProjectName: 1, Alert: 'abc') do |response|
        assert response.respond_to?(:body)
      end

    end
  end
end