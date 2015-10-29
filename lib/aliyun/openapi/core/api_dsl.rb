module Aliyun
  module Openapi

    # v20140526.ecs do |api|
    #   api.instances do |collection|
    #     collection.create_instance do |end_point|
    #       end_point.param :param1, :int
    #       end_point.param :param1, :string
    #     end
    #     collection.start_instance do |end_point|
    #
    #     end
    #   end
    # end
    class ApiDSL

      def initialize

      end

      class << self
        attr_reader :world

        def initialize
          @world = {}
        end

        def build(name_space)
          self.new.name_space
        end
      end

      def method_missing(symbol, *args)
        unless block_given?
        end
      end

    end
  end
end
