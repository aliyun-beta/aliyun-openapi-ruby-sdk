%w[
  version
  configuration
  api_dsl
  exception
  client
].each { |name| require "aliyun/openapi/core/#{name}" }

module Aliyun
  module Openapi
    class << self
      # Setters for shared global objects
      # @api private
      attr_writer :configuration, :world
    end

    # Used to ensure examples get reloaded and user configuration gets reset to
    # defaults between multiple runs in the same process.
    #
    # Users must invoke this if they want to have the configuration reset when
    # they use the runner multiple times within the same process. Users must deal
    # themselves with re-configuration of OpenAPI before run.
    # def self.reset
    #   @world = nil
    #   @configuration = nil
    # end

    # Yields the global configuration to a block.
    # @yield [Configuration] global configuration
    #
    # @example
    #     Aliyun::Openapi.configure do |config|
    #       config.server_address 'ecs.aliyuncs.com'
    #       config.require_ssl true
    #     end
    # @see Core::Configuration
    def self.configure
      @configuration ||= Configuration.new
      yield @configuration if block_given?
    end

    def self.config
      @configuration
    end
  end
end