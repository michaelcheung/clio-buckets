class UserSerializer < ActiveModel::Serializer
  
  cache key: 'user', expires_in: 24.hours

  attributes :id, :full_name, :email, :department_id

  has_many :roles
  has_many :direct_reports, serializer: UserSerializer  

end
