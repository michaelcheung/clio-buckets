class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
      user = User.from_omniauth(request.env["omniauth.auth"])

      if user
        sign_in user, event: :authentication
        redirect_to "/app.html"
      end
  end
end
