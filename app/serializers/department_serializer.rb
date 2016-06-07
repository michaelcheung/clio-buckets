class DepartmentSerializer < ActiveModel::Serializer

  cache key: 'department', expires_in: 24.hours
  
  attributes :id, :name

end
