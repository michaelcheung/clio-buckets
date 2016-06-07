class GrantSerializer < ActiveModel::Serializer

  attributes :id, :reason, :granter_id, :secondary_granter_id, :competency_id, :approved

  has_one :grantee, serializer: UserSerializer, only: [ :id, :full_name ]
  has_one :granter, serializer: UserSerializer, only: [ :id, :full_name ]
  has_one :secondary_granter, serializer: UserSerializer, only: [ :id, :full_name ]
  has_one :competency, serializer: CompetencySerializer, only: [ :id, :name ]


end
