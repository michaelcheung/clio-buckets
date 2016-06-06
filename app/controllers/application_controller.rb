class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  respond_to :json

  
  include ActionController::RequestForgeryProtection
  include ActionController::Cookies
  include ActionController::RespondWith
  include ActionController::MimeResponds

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  after_filter :set_csrf_cookie

  def after_sign_out_path_for(user)
    "/unauthed.html"
  end

  def set_csrf_cookie
    # Set the CSRF cookie to be picked up by Angular if the response is NOT committed
    if protect_against_forgery? && !response.committed?
      cookies['XSRF-TOKEN'] = {
        value: form_authenticity_token,
      }
    end
  end

  def verified_request?
    # Here, we also check the 'X-XSRF-TOKEN' in the case that Angular is submitting the request.
    # When performing XHR requests, the $http service reads a token from a cookie (by default, XSRF-TOKEN) and sets it as an HTTP header (X-XSRF-TOKEN).
    # This cookie is set in the :set_csrf_cookie filter above.
    # For more info see: https://docs.angularjs.org/api/ng/service/$http
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

end
