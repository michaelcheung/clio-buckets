class UserSerializer < ActiveModel::Serializer

  attributes :id, :full_name, :email

  has_many :roles
  has_many :direct_reports, serializer: UserSerializer

end
