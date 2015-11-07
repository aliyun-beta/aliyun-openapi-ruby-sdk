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

          def defined?
            !@root.nil?
          end

          def client(opts={})
            #region
            c = @root.dup
            c.read_only = true
            c
          end
        end

        attr_reader :name, :children, :type

        attr_accessor :read_only

        def initialize(name, parent = nil)
          @parent = parent
          @name = name
          @children = {}
          @read_only = false
          if parent
            if parent.type == :root
              @type = :product
            end
          else
            @type = :root
          end
        end

        def method_missing(symbol, *args)
          # p symbol
          node = @children[symbol]
          if node.respond_to? :read_only=
            node.read_only = @read_only
          end
          unless node
            raise RuntimeError, 'Not defined' if @read_only
            node = ApiDSL.new(symbol, self)
            @children[symbol] = node
          end
          hash = args
          #version check

          if !hash.empty?  && hash[0][:version]
            node = node.send(hash[0][:version].to_sym)
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

        def product
          @type == :product ? @name : @parent.product
        end
      end


      class EndPoint

        def initialize(name, parent = nil)
          @parent = parent
          @name = name
          @params = {}
        end

        def param(name, type, required, options= {})
          @params[name] = {type: type, required: required, options: options}
        end

        def exec_call(params={})
          # validate params
          validate_params(params)

          # Client.build(self)
          return Result.new(params)
        end

        def to_s(opts={})
          "#{@name} => [%s]" % @params.map { |k, v| "#{k} -> #{v}" }.join(';')
        end

        def product
          @parent.product
        end

        private


        def validate_params(params)
          required = required_params.keys - params.keys
          unless required.empty?
            # raise RuntimeError
            raise InvalidParamsError, "Following Params Required : [#{required.map(&:to_s).join(',')}]"
          end
          type_errors = []
          params.each do |k,v|
            unless valid_type?(v, @params[k][:type])
              type_errors << " #{key} : #{value} is not type of #{@params[k][:type]}"
            end
          end
          raise InvalidParamsError, "Invalid Value of Params: #{type_errors.join(' | ')}" unless type_errors.empty?
        end

        def required_params
          @required_params ||= @params.select{|k,v| v[:required]}
        end

        def valid_type?(type, value)
          true
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
