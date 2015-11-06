require 'find'
require 'json'
require 'rainbow'
require 'yaml'
require 'rexml/document'
require 'active_support/core_ext/hash'

namespace :codegen do
  desc "build index of api product"
  task :index do
    version_files(verbose: true)
  end

  desc "build code from template"
  task :build do
    files = version_files
    files.each do |path|
      data = JSON.parse(File.read(path))
    end
  end

  desc "generate code from template"
  task :generate_code do
    products = `ls openapi-meta/api-metadata`.split("\n")
    products.each do |product|
      files = []
      # next unless product == 'aliyun-api-metadata-ecs'
      versions = `ls openapi-meta/api-metadata/#{product}`.split("\n")
      versions.each do |version|
        api_names = JSON.parse(File.read("openapi-meta/api-metadata/#{product}/#{version}/Version-Info.json"))
        api_names["apis"]["apis"].each do |name_h|
          # next unless name_h["name"] == 'CreateInstance'
          api_detail = JSON.parse(File.read("openapi-meta/api-metadata/#{product}/#{version}/Api/#{name_h["name"]}.json")) rescue break
          version_in_rb = "#{version.delete('-')}"
          api_name_in_rb = underscore(name_h["name"])
          @version = version
          @api_name = api_name_in_rb
          @api_name_camel_case = name_h["name"]
          @product = product.gsub(/aliyun-api-metadata-/, '').gsub('-','_')
          @name_space = api_names["product"]
          @api_params = api_detail["parameters"]["parameters"]
          template('templates/api_define.rb', "generated/lib/aliyun/openapi/#{@product}/#{@version}/#{api_name_in_rb}.rb")
          template('templates/api_test.rb', "generated/test/aliyun/openapi/#{@product}/#{@version}/#{api_name_in_rb}_test.rb")
          files << "aliyun/openapi/#{@product}/#{@version}/#{api_name_in_rb}"
        end
        @files = files
        template('templates/api_product.rb', "generated/lib/aliyun/openapi/#{@product}.rb")
      end
    end

    #
    # template 'lib/generators/api_define.rb', File.join('app/controllers', class_path, "#{file_name}_controller.rb")
  end


  def version_files(options={})
    index = []
    Find.find('openapi-meta') do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == ?.
          Find.prune # Don't look any further into this directory.
        else
          next
        end
      else
        if File.basename(path).end_with?('Version-Info.json')
          begin
            JSON.parse(File.read(path))
            puts "#{Rainbow('[INDEX]').green} ..... #{path}" if options[:verbose]
            index << path
          rescue
            puts "#{Rainbow('[ERROR]').red} ..... #{path}" if options[:verbose]
          end
        end
      end
    end
    index
  end


  desc "generate endpoint from xml"
  task :endpoint do
    target = {}
    doc = {}
    File.open( 'openapi-meta/endpoints.xml' ) { |xf| doc = Hash.from_xml( xf ) }
    doc['Endpoints']['Endpoint'].each do |ep|
      target[ep['name'].to_sym] = {
          region_ids: [ep['RegionIds']['RegionId']].flatten,
          products: ep['Products']['Product'].map{|prod| [prod['ProductName'].downcase.to_sym, prod['DomainName']]}.to_h
      }
    end
    File.open( 'lib/aliyun/openapi/endpoints.yml', 'w' ) { |f| f.write( target.to_yaml ) }
  end

# Gets an ERB template at the relative source, executes it and makes a copy
# at the relative destination.
#
# ==== Parameters
# source<String>:: the relative path to the source root.
# destination<String>:: the relative path to the destination root.
#
# ==== Examples
#
#   template "README", "doc/README"
#
#   template "doc/README"
#
  def template(source, *args, &block)
    config = args.last.is_a?(Hash) ? args.pop : {}
    destination = args.first
    context = instance_eval("binding")

    content = ERB.new(::File.binread(source), nil, "-", "@output_buffer").result(context)
    content = block.call(content) if block

    FileUtils.mkdir_p(File.dirname(destination))
    File.open(destination, "wb") { |f| f.write content }
  end

  def underscore(camel_cased_word)
    return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
    word = camel_cased_word.to_s.gsub(/::/, '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

end