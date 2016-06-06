class CompetencySerializer < ActiveModel::Serializer

  attributes :id, :category, :name, :rank

  has_many :roles

end
