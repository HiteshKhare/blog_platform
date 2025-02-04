class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!

  def after_sign_out_path_for(resource_or_scope)
    root_path # Or wherever you want to redirect after logout
  end

end
