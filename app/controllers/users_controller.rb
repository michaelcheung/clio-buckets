class UsersController < ApplicationController

  def index
    department = Department.find(params.require(:department_id))
    @users = department.users.limit(100).order(:full_name)
    render json: @users
  end

end
