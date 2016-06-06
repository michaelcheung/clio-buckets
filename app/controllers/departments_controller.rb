class DepartmentsController < ApplicationController

  def index
    @departments = Department.joins(:roles).uniq.limit(100).order(:name)
    render json: @departments
  end

end
