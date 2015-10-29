module Aliyun
  module Openapi
    class Client
      class << self

        def define(api_version)
          ApiDSL.build(api_version)
        end

        def method_missing(symbol, *args)

        end
      end
    end
  end
end
