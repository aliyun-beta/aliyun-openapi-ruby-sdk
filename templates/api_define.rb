require 'aliyun/openapi'

module Aliyun::Openapi
  Core::ApiDSL.define('openapi').<%= @product %>(version: '<%= @version %>').end_point do |end_point|
        <% @api_params.each do |param| %><% rest_param = param.reject {|k,v| ['tagName', 'type', 'required'].include? k} %>
          end_point.param <%= ":'#{param['tagName']}', :#{param['type']}, #{param['required']}, #{rest_param}" %>
        <% end %>
  end
end