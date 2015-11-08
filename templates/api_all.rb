require 'aliyun/openapi'
<%@products.each do |file|%>
require '<%= file %>'<% end %>