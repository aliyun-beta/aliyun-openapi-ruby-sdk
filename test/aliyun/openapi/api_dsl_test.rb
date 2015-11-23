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
        config.format = :json
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
        Client.xxx(version: '2014-05-26').create_mock_instance(param1: 1, param2: 'abc') do |response|
        end
      end

      assert_raises(RuntimeError) do
        Client.ecs(version: '2014-05-27').create_mock_instance(param1: 1, param2: 'abc') do |response|
        end
      end


      Client.ecs(version: '2014-05-26').create_mock_instance(param1: 1, param2: 'abc') do |response|
        assert response.respond_to?(:body)
        # p response.body
        # assert response.respond_to?(:parsed_result)
      end

      Client.ecs(version: '2014-05-26').create_mock_instance(param1: 1, param2: 'abc') do |response|

      end

      # puts Core::ApiDSL.root.to_s(level: 0)
    end

    def test_invalid_params
      assert_raises(InvalidParamsError) do
        Client.ecs(version: '2014-05-26').create_mock_instance(param1: 1) do |response|
          assert response.respond_to?(:body)
          # assert response.respond_to?(:parsed_result)
        end
      end
    end

    def test_end_point
      assert_equal :ecs, Client.ecs(version: '2014-05-26').create_mock_instance.product
      assert_equal "create_mock_instance => [param1 -> {:type=>:integer, :required=>false, :options=>{}};param2 -> {:type=>:string, :required=>true, :options=>{}}]", Client.ecs(version: '2014-05-26').create_mock_instance.to_s
      assert !Client.ecs(version: '2014-05-26').to_s.empty?
      assert_equal :ecs, Client.ecs(version: '2014-05-26').product.name
      assert_equal :'2014-05-26', Client.ecs(version: '2014-05-26').version.name
    end

    def test_build_url
      assert_kind_of Core::EndPoint, Client.ecs(version: '2014-05-26').create_mock_project
      assert_equal '/projects/1/alerts?Action=CreateMockProject&Type=Integer&Version=2014-05-26', Client.ecs(version: '2014-05-26').create_mock_project.build_url('ProjectName' => 1, 'Alert' => 'abcdefg', 'Type' => 'Integer')
    end

    def test_endpoints_with_different_versions
      Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version: '2014-05-26').create_mock_endpoint.end_point do |end_point|
        end_point.param :'ProjectName', :Integer, true, 'tagPosition' => 'Path'
        end_point.param :'Alert', :String, true, 'tagPosition' => 'Body'
        end_point.param :'Type', :String, false, 'tagPosition' => 'Query'
        end_point.pattern = "/projects/[ProjectName]/alerts"
        end_point.methods = ['POST']
      end

      Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version: '2014-06-26').create_mock_endpoint.end_point do |end_point|
        end_point.param :'ProjectName', :Integer, true, 'tagPosition' => 'Path'
        end_point.param :'Alert', :String, true, 'tagPosition' => 'Body'
        end_point.param :'Type', :String, false, 'tagPosition' => 'Query'
        end_point.pattern = "/projects/[ProjectName]/alerts"
        end_point.methods = ['POST']
      end

      Client.ecs(version: '2014-05-26').create_mock_endpoint(ProjectName: 1, Alert: 'abc') do |response|
        assert response.respond_to?(:body)
      end
      Client.ecs(version: '2014-06-26').create_mock_endpoint(ProjectName: 1, Alert: 'abc') do |response|
        assert response.respond_to?(:body)
      end

    end

    def test_type_validation
      Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version: '2014-06-26').create_mock_test_type.end_point do |end_point|
        end_point.param :'String',  :String,  false, 'tagPosition' => 'Query'
        end_point.param :'Integer', :Integer, false, 'tagPosition' => 'Query'
        end_point.param :'Long',    :Long,    false, 'tagPosition' => 'Query'
        end_point.param :'Float',   :Float,   false, 'tagPosition' => 'Query'
        end_point.param :'List',    :List,    false, 'tagPosition' => 'Query'
        end_point.param :'Boolean', :Boolean, false, 'tagPosition' => 'Query'
        end_point.methods = ['GET']
      end
      assert Client.ecs(version: '2014-06-26').create_mock_test_type(String: '', Integer: 12345, Long: 12342341124124234, Float: 1234.555, List: '123,314124,152435', Boolean: true)
      [[:'String', 1234], [:'Integer', 'abc'], [:'Long', 1.2], [:'Float', 1], [:'List', ''], [:'Boolean', 1234]].each do |value|
        assert_raises(InvalidParamsError) do
          Client.ecs(version: '2014-06-26').create_mock_test_type(value[0] => value[1]) {|request| }
        end
      end
    end

    def test_call_without_block
      Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version: '2014-06-26').create_mock_get.end_point do |end_point|
        end_point.methods = ['GET']
      end
      Client.ecs(version: '2014-06-26').create_mock_get() {|request| }
      assert true # pass last call
    end
  end
end