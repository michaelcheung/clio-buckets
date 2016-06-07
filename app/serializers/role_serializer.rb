class RoleSerializer < ActiveModel::Serializer

  cache key: 'role', expires_in: 24.hours

  attributes :id, :department_id, :name

end
