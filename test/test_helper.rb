$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/openapi'
require 'pry'
require 'minitest/autorun'



Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs.v20140526 do |api|
  api.instances do |collection|
    collection.create_instance.end_point do |end_point|
      end_point.param :param1, :int
      end_point.param :param2, :string, required: true
    end
    collection.start_instance.end_point do
    end
  end
end