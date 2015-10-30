module Aliyun
  module Openapi
    module Core
      # ClientBuilder.ecs('v20140526') do |api|
      #   api.instances do |collection|
      #     collection.create_instance.end_point do
      #       param :param1, :int
      #       param :param1, :string
      #     end
      #     collection.start_instance.end_point do
      #
      #     end
      #   end
      # end

      # Client.new.ecs('v20140526').instances.create_instance(param1: 1, param2: 'abc')
      #

      # namespace dsl
      # api dsl
      #  root . 2nd level . 3rd level . 4th level
      #
      class ApiDSL

        attr_reader :name, :children

        def initialize(name, parent = nil)
          @parent = parent
          @name = name
          @children = {}
        end

        class << self

          attr_reader :root

          def define(name)
            @root ||= ApiDSL.new(name)
          end
        end

        def method_missing(symbol, *args)
          p symbol
          node = ApiDSL.new(symbol, self)
          @children[symbol] = node
          if block_given?
            yield node
          else
            node
          end
        end

        def to_s
          "{ #{@children.map { |k, v| "#{k} : #{v}" if v }.join(',')}}"
        end

        def end_point(&block)
          ep = EndPoint.new(@name, @parent)
          yield ep
          @parent.children[name] = ep
        end
      end


      class EndPoint

        def initialize(name, parent = nil)
          @parent = parent
          @name = name
          @params = {}
        end

        def param(name, type, options= {})
          @params[name] = type
        end

        def to_s
          "#{@name} => [%s]" % @params.map{|k,v| "#{k} -> #{v}"}.join(';')
        end
      end
    end
  end
end
