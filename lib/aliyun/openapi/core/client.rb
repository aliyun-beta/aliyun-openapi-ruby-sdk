require 'faraday'
require 'faraday_middleware'
require 'aliyun/openapi/faraday/openapi_sign'
module Aliyun
  module Openapi
    module Core
      class Client
        class << self
          def exec(end_point)

          end


          def build(end_point, query)
            format_query = "&Format=#{Openapi.config.format.to_s.upcase}"
            url = (Openapi.config.ssl_required ? 'https' : 'http') + '://' + Openapi.config.look_up_server(end_point.product) + query + format_query
            connection end_point: url
          end

          # private
          def connection(opts = {})
            options = {
                :headers => {'Accept' => "application/json; charset=utf-8", 'User-Agent' => 'Ruby'},
                # :proxy => proxy,
                :url => opts[:end_point]
            } #.merge(opts)
            ::Faraday::Connection.new(options) do |connection|
              connection.use Faraday::OpenapiSign, Openapi.config.access_key_id, Openapi.config.access_key_secret
              connection.use ::Faraday::Request::UrlEncoded
              connection.use ::FaradayMiddleware::Mashify if opts[:raw]
              # unless raw
              #   case format.to_s.downcase
              #     when 'json' then connection.use Faraday::Response::ParseJson
              #   end
              # end
              if Openapi.config.format == :xml
                connection.use ::Faraday::Response::ParseXML
              else
                connection.use ::Faraday::Response::ParseJson
              end
              # connection.use FaradayMiddleware::RaiseHttpException
              # connection.use FaradayMiddleware::LoudLogger if loud_logger
              connection.adapter(::Faraday::default_adapter)
            end
          end
        end
      end
    end
  end
end
