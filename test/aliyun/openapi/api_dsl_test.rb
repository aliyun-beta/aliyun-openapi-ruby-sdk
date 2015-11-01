require File.expand_path('../../../test_helper', __FILE__)
module Aliyun::Openapi
  class ApiDSLTest < Minitest::Test


    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup

    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def teardown
      # Do nothing
    end

    # test dsl
    def test_define_client_by_dsl

      assert_raises(RuntimeError) do
        Core::ApiDSL.client.xxx.v20140526.instances.create_instance(param1: 1, param2: 'abc') do |response|
        end
      end

      assert_raises(RuntimeError) do
        Core::ApiDSL.client.ecs.v20140527.instances.create_instance(param1: 1, param2: 'abc') do |response|
        end
      end


      Core::ApiDSL.client.ecs.v20140526.instances.create_instance(param1: 1, param2: 'abc') do |response|
        assert response.respond_to?(:body)
        assert response.respond_to?(:parsed_result)
      end

      Core::ApiDSL.client.ecs.v20140526.instances.create_instance(param1: 1, param2: 'abc') do |response|

      end

      puts Core::ApiDSL.root.to_s(level: 0)
    end

    def test_invalid_params
      assert_raises(InvalidParamsError) do
        Core::ApiDSL.client.ecs.v20140526.instances.create_instance(param1: 1) do |response|
          assert response.respond_to?(:body)
          assert response.respond_to?(:parsed_result)
        end
      end
    end
  end
end