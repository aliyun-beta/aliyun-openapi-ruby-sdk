Core::ApiDSL.define('openapi').ecs.<%= @version %> do |api|
  api.instances do |collection|
    collection.<%= @api_name %>.end_point do |end_point|
      <% @api_params.each do |param| %>
      end_point.param <%= ":'#{param['tagName']}', :#{param['type']}, :#{param['required']}, :#{param['tagPosition']}, :#{param['valueSwitch']}" %>
      <% end %>
    end
  end
end
