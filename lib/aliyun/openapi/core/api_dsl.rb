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



        class << self

          attr_reader :root

          def define(name)
            @root ||= ApiDSL.new(name)
          end

          def client
            c = @root.dup
            c.read_only = true
            c
          end
        end

        attr_reader :name, :children

        attr_accessor :read_only

        def initialize(name, parent = nil)
          @parent = parent
          @name = name
          @children = {}
          @read_only = false
        end

        def method_missing(symbol, *args)
          # p symbol
          node = @children[symbol]
          node.read_only = @read_only if node.respond_to? :read_only=
          unless node
            raise RuntimeError,'Not defined' if @read_only
            node = ApiDSL.new(symbol, self)
            @children[symbol] = node
          end

          if block_given?
            if (node.is_a? EndPoint)
              yield node.exec_call(*args)
            else
              yield node
            end

          else
            node
          end
        end

        def to_s(opts = {})
          space = "_" * opts[:level] if opts[:level]
          spece = "\n#{space}"
          "#{space}{ #{@children.map { |k, v| "#{k} : #{v.to_s(level: opts[:level] ? opts[:level] + 1: nil)}" if v }.join(',')}}"
        end

        def end_point(&block)
          ep = EndPoint.new(@name, @parent)
          yield ep
          # puts @parent.to_s
          @parent.children[name] = ep
          # puts @parent.to_s
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

        def exec_call(params={})
          # validate params

          return Result.new(params)
        end

        def to_s(opts={})
          "#{@name} => [%s]" % @params.map { |k, v| "#{k} -> #{v}" }.join(';')
        end
      end

      class Result
        attr_reader :body, :parsed_result

        def initialize(opts={})
          # exec api call
        end
      end
    end
  end
end
