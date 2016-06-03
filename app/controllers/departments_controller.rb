class DepartmentsController < ApplicationController

  def index
    @departments = Department.limit(100).order(:name)
    render json: @departments
  end

end
