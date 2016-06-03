class CompetenciesController < ApplicationController

  def index
    user = User.find(params.require(:user_id))
    @competencies = user.competencies.limit(100).order(:rank)
    render json: @competencies
  end

end
