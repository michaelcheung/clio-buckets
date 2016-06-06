class GrantsController < ApplicationController

  def index
    user = User.find(params.require(:user_id))
    grants = user.received_grants.limit(100)
    render json: grants
  end

  def create
    user = User.find_for_manager(current_user, params.require(:user_id))
    competency = user.competencies.find(params[:competency_id])
    grant = Grant.create!(grantee: user, granter: current_user, competency: competency, reason: params[:reason])
    render json: grant                      
  end

end
