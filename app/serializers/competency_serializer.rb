class CompetencySerializer < ActiveModel::Serializer

  cache key: 'competency', expires_in: 24.hours

  attributes :id, :category, :name, :rank

end
