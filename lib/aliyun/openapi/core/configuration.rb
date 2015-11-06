require 'ostruct'

module Aliyun
  module Openapi

    END_POINTS_FILE = File.expand_path('../../endpoints.yml', __FILE__)

    class Configuration #< OpenStruct
      attr_accessor :server_address, :ssl_required, :token
      attr_reader :end_points
      def initialize
        @end_points = YAML.parse( File.read(END_POINTS_FILE) ).transform
        @end_points.frozen? #make it read only
      end
    end
  end
end
