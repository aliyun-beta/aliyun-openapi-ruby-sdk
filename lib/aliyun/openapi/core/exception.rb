module Aliyun
  module Openapi

    # all error before making api call
    class LocalError < StandardError

    end

    # invalid api entry or namespace
    class UndefinedError < LocalError

    end

    # invalid params, either type or required
    class InvalidParamsError < LocalError

    end
  end
end
