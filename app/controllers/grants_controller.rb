class GrantsController < ApplicationController

  def index
    user = User.find(params.require(:user_id))
    grants = user.received_grants.limit(100)
    render json: grants
  end

  def create
    user = current_user.department.users.find(params.require(:user_id))
    competency = user.competencies.find(params[:competency_id])
    grant = Grant.new(grantee: user, granter: current_user, competency: competency, reason: params[:reason])
    grant.approved = true if user.managers.include?(current_user)
    grant.save!
    render json: grant                      
  end

end
