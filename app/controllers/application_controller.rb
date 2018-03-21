class ApplicationController < ActionController::Base
  include Pundit
  before_action :coordinates
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    redirect_to root_path, notice: 'You are not authorized to perform that action!'
  end

  def current_user
    super || guest_user
  end

  def guest_user
    User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
  end

  def create_guest_user
    token = SecureRandom.base64(15)
    user = User.new({password: token, email: "#{token}@example.com"}.merge!(@coordinates))
    user.save(validate: false)
    user
  end

  def set_edition
    if User.near([59.224443,18.198229], 15).include? current_user
      @edition = 'Stockholm Edition'
    else
      @edition = 'West Coast Edition'
    end
  end


  def coordinates
    @coordinates = {}
    if cookies['geocoderLocation'].present?
      @coordinates = JSON.parse(cookies['geocoderLocation']).to_hash.symbolize_keys
      set_edition
      @geocoded = true
    else
      @geocoded = false
    end
  end
end
