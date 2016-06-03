class RolesController < ApplicationController

  def index
    department = Department.find(params.require(:department_id))
    @roles = department.roles.limit(100).order(:name)
    render json: @roles
  end

end
