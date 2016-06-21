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
    grant.approved = true if current_user.can_manage?(user)
    grant.save!
    render json: grant
  end

  def edit_modal
    render layout: false
  end

  def update
    grant = Grant.find(params.require(:id))

    # If the current user is the same as the granter, the current user is likely
    # updating a recommendation.
    grant.secondary_granter = current_user if grant.granter != current_user
    grant.approved = [true, "true"].include?(params[:approved]) if current_user.can_manage?(grant.grantee)
    grant.reason = params[:reason] if params[:reason]
    grant.save!
    render json: grant

  end

end
