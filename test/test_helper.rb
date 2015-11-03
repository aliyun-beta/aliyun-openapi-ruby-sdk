$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/openapi'
require 'pry'
require 'minitest/autorun'



Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-05-26') do |api|
  api.instances do |collection|
    collection.create_instance.end_point do |end_point|
      end_point.param :param1, :int, false
      end_point.param :param2, :string, true
    end
    collection.start_instance.end_point do
    end
  end
end