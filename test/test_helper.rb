$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/openapi'
require 'pry'
require 'minitest/autorun'
require 'rainbow'
require 'find'
$LOAD_PATH.unshift File.expand_path('../../generated/lib', __FILE__)
#
# Dir[File.expand_path('../../generated/lib/aliyun/openapi/*.rb', __FILE__)].each do |path|
#   require path.gsub(/^.*generated\/lib\/(.*)\.rb/, '\1')
# end

# Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-05-26') do |api|
#   api.instances do |collection|
#     collection.create_instance.end_point do |end_point|
#       end_point.param :param1, :int, false
#       end_point.param :param2, :string, true
#     end
#     collection.start_instance.end_point do
#     end
#   end
# end

Aliyun::Openapi::Core::ApiDSL.define('openapi').ecs(version:'2014-05-26').create_instance.end_point do |end_point|
  end_point.param :param1, :int, false
  end_point.param :param2, :string, true
end