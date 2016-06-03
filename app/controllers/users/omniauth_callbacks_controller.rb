class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :authenticate_user!

  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    
    if user
      sign_in user, event: :authentication
      redirect_to "/app.html"
    else
      redirect_to "/"      
    end
  end

  def failure
    redirect_to "/"    
  end

end
