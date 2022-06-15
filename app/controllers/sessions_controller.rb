class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_parmas[:email])

    if user&.authenticate(session_parmas[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました'
    else
      render :new
    end
  end

  private

  def session_parmas
    params.require(:session).permit(:email, :password)
  end
end
