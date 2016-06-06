class UsersController < ApplicationController

  def index
    department = Department.find(params.require(:department_id))
    users = department.users.preload(:roles).limit(100).order(:full_name)
    render json: users, except: [:direct_reports]
  end

  def who_am_i
    render json: current_user
  end
  
  def update
    user = User.find_for_manager(current_user, params.require(:id))
    
    user.update_roles(params[:roles]) if params.key?(:roles)

    render json: user
  end

end
