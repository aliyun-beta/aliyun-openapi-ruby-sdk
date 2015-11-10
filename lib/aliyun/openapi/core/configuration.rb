require 'ostruct'
require 'yaml'

module Aliyun
  module Openapi

    END_POINTS_FILE = File.expand_path('../../endpoints.yml', __FILE__)

    class Configuration #< OpenStruct
      attr_accessor :server_address, :ssl_required, :access_key_id, :access_key_secret, :format, :region
      attr_reader :end_points
      def initialize
        @end_points = YAML.parse( File.read(END_POINTS_FILE) ).transform
        @format = :json
        @region = 'cn-hangzhou'
        @end_points.frozen? #make it read only
      end

      def look_up_server(product, region = nil)
        setting = @end_points.select {|k,v| v[:region_ids].include?(region || @region)}
        setting.values[0][:products][product.to_s.gsub(/_/, '-').to_sym] unless setting.empty?
      end
    end
  end
end
