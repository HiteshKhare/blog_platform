class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!

  # Redirect after login based on user role (admin or regular user)
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path  # Redirect admin to the dashboard (Post Analytics page)
    else
      root_path  # Redirect regular users to the posts index page
    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_path # Or wherever you want to redirect after logout
  end

end
