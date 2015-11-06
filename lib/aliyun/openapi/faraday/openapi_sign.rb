require 'faraday'
require 'time'
require 'digest'
require 'base64'
require 'securerandom'
# require 'openssl'
# require 'uri'

# @private
module Aliyun::Openapi::Faraday
  # @private
  class OpenapiSign < Faraday::Middleware
    def call(env)
      query = Faraday::Utils.parse_query(env[:url].query) unless env[:url].query.nil?
      query ||= {}
      p Time.now.utc.iso8601
      query.merge!({'AccessKeyId' => @access_key_id,
                    'SignatureMethod' => 'HMAC-SHA1',
                    'Timestamp' => Time.now.utc.iso8601,
                    'SignatureVersion' => '1.0',
                    'SignatureNonce' => SecureRandom.hex,
                    'Signature' => generate_sign(env[:method], query)})
      env[:url].query = Faraday::Utils.build_query(query)
      @app.call env
    end

    def generate_sign method, options = {}
      query_str = options.keys.sort.map { |k| URI.encode(k) + '=' + URI.encode(options[k]) }.join('&')
      sign = method.to_s.upcase + '&' + URI.encode('/') + '&' + URI.encode(query_str)
      hmac = OpenSSL::HMAC.digest('sha1', @access_key_secret + '&', sign)
      Base64.encode64 hmac
    end

    def initialize(app, access_key_id, access_key_secret)
      @app = app
      @access_key_secret = access_key_secret
      @access_key_id = access_key_id
    end
  end
end