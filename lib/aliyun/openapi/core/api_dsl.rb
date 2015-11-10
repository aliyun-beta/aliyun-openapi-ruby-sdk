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

          # def defined?
          #   !@root.nil?
          # end

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
            case parent.type
              when :root
                @type = :product
              when :product
                @type = :version
            end
          else
            @type = :root
          end
        end

        def method_missing(symbol, *args)

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
          if !hash.empty? && hash[0][:version]
            node = node.send(hash[0][:version].to_sym)
          end

          if block_given?
            if node.is_a? EndPoint
              yield node.exec_call(*args)
            end
          else
            node
          end
        end

        def to_s(opts = {})
          space = '_' * (opts[:level] || 0)
          space = "\n#{space||''}"
          "#{space}{ #{@children.map { |k, v| "#{k} : #{v.to_s(level: opts[:level] ? opts[:level] + 1 : nil)}" if v }.join(',')}}"
        end

        def end_point
          ep = EndPoint.new(@name, @parent)
          yield ep
          @parent.children[name] = ep
        end

        def product
          @type == :product ? self : @parent.product
        end

        def version
          @type == :version ? self : @parent.version
        end
      end


      # EndPoint class is the end point description
      class EndPoint

        def initialize(name, parent = nil)
          @parent = parent
          @name = name
          @params = {}
          @params_types = {}
          @methods = []
          @pattern = nil
        end

        def param(name, type, required, options= {})
          @params[name] = {type: type, required: required, options: options}
        end

        def methods=(methods)
          @methods = methods.sort.map { |v| v.downcase.to_sym } # GET over POST
        end

        def pattern=(pattern)
          @pattern = pattern.gsub(/\[/, '%{').gsub(/\]/, '}') # build a ruby format syntax 
        end

        def exec_call(params={})
          # validate params
          validate_params(params)
          conn = Client.build(self, build_url(params))

          method = @methods.first || :get
          conn.send(method) do |request|
            body_prams = params_by_type(:body)
            request.body = filter_params(params, body_prams) if !body_prams.nil? && !body_prams.empty?
          end
        end

        def to_s(opts={})
          "#{@name} => [%s]" % @params.map { |k, v| "#{k} -> #{v}" }.join(';')
        end

        def version
          @version ||= @parent.version.name
        end

        def product
          @product ||= @parent.product.name
        end

        def build_url(params = {})
          url = @pattern ? @pattern % filter_params(params, params_by_type(:path)) : ''
          "#{url}?#{::Faraday::Utils.build_query(action_query.merge(filter_params(params, params_by_type(:query))))}"
        end

        private

        def action_query
          {'Action': @name.to_s.split('_').collect(&:capitalize).join,
           'Version': version.to_s}
        end

        def filter_params(params, filter)
          params.select { |k, v| filter[k] }
        end

        # could be :query, :path, :body
        def params_by_type(type)
          @params_types[type] ||= @params.select do |k, v|
            @params[k][:options]['tagPosition'] == type.to_s.capitalize
          end
        end

        def validate_params(params)
          required = required_params.keys - params.keys
          unless required.empty?
            # raise RuntimeError
            raise InvalidParamsError, "Following Params Required : [#{required.map(&:to_s).join(',')}]"
          end
          type_errors = []
          params.each do |k, v|
            unless valid_type?(@params[k][:type], v)
              type_errors << " #{k} : #{v} is not type of #{@params[k][:type]}"
            end
          end
          raise InvalidParamsError, "Invalid Value of Params: #{type_errors.join(' | ')}" unless type_errors.empty?
        end

        def required_params
          @required_params ||= @params.select { |k, v| v[:required] }
        end

        def valid_type?(type, value)
          begin
            case type.to_s.capitalize
              when 'Boolean'
                value.equal?(true) || value.equal?(false)
              when 'Long'
                value.is_a? Integer
              when 'List'
                value.is_a?(String) && value.split(',').size > 0
              else
                value.is_a?(Object.const_get(type.to_s.capitalize))
            end
          rescue
            p type
          end
        end
      end

      # class Result
      #   attr_reader :body, :parsed_result
      #
      #   def initialize(opts={})
      #     # exec api call
      #   end
      # end
    end
  end
end
