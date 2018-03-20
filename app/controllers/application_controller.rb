class ApplicationController < ActionController::Base


  def authorize_user_as_author
    if current_user && current_user.role != 'author'
      redirect_to root_path, notice: 'You are not authorized to perform that action!'
    end
  end

end
