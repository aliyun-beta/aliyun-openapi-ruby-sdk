require 'ostruct'

module Aliyun
  module Openapi
    class Configuration #< OpenStruct
      attr_accessor :server_address, :ssl_required, :token
    end
  end
end
