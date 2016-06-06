class CompetenciesController < ApplicationController

  def index
    if params[:user_id]
      scope = User.find(params.require(:user_id)).competencies
    else
      scope = Department.find(params.require(:department_id)).competencies
    end
    @competencies = scope.limit(200).order(:rank)
    render json: @competencies
  end

end
