class GrantSerializer < ActiveModel::Serializer

  attributes :id, :reason, :granter_id, :secondary_granter_id, :competency_id

end
