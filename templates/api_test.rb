require File.expand_path('../../../../../../../test/test_helper', __FILE__)
<% required_params = [] %>
<% @api_params.each do |param|
  required_params << param if  param['required']
end %>
module Aliyun::Openapi
  class <%= @product.capitalize %>Test < ApiTest
    def test_<%=@api_name%>_<%= @version.delete('-')%>
      Client.<%= @product %>(version: '<%= @version %>').<%= @api_name %>() do |response|
      	assert !response.nil?
      end
    end
  end
end
