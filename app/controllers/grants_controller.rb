class GrantsController < ApplicationController

  def index
    user = User.find(params.require(:user_id))
    grants = user.received_grants.preload(:competency, :grantee, :granter, :secondary_granter).limit(100)
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

  def edit_modal
    render layout: false
  end

  def update
    grant = Grant.find(params.require(:id))
    raise ActiveRecord::RecordNotFound unless grant.grantee.managers.include?(current_user)
    
    grant.secondary_granter = current_user
    grant.approved = [true, "true"].include?(params[:approved])
    grant.reason = params[:reason] if params[:reason]
    grant.save!
    render json: grant

  end

end
