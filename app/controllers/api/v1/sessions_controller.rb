class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token, only: :create

  def create
    user = User.find_by_email(params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { user: user, token: token }, status: :created
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: { user: resource, token: request.env['warden-jwt_auth.token'] }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end


