class GrantsController < ApplicationController

  def index
    user = User.find(params.require(:user_id))
    @grants = user.received_grants.limit(100)
    render json: @grants
  end

end
