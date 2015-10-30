require File.expand_path('../../../test_helper', __FILE__)
module Aliyun::Openapi
  class ApiDSLTest < Minitest::Test

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

    # test dsl
    def test_define_client_by_dsl
      Core::ApiDSL.define('openapi').ecs.v20140526 do |api|
        api.instances do |collection|
          collection.create_instance.end_point do |end_point|
            end_point.param :param1, :int
            end_point.param :param2, :string
          end
          collection.start_instance.end_point do
          end
        end
      end

      puts Core::ApiDSL.root.to_s
    end
  end
end