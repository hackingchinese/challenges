class <%= controller_class_name %>Controller < InheritedResources::Base
<% if options[:singleton] -%>
defaults :singleton => true
<% end -%>
  load_and_authorize_resource
  def permitted_params
    params.permit!
  end
end
