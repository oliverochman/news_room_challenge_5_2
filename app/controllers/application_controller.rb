class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    redirect_to root_path, notice: 'You are not authorized to perform that action!'
  end

  def current_user
    super || create_guest_user
  end

  def create_guest_user
    token = SecureRandom.base64(15)
    user = User.new({password: token, email: "#{token}@example.com"}.merge!(@coordinates))
    user.save(validate: false)
    user
  end


end
