class Grant < ActiveRecord::Base
  
  belongs_to :competency
  belongs_to :granter, class_name: "User"
  belongs_to :secondary_granter, class_name: "User"

  belongs_to :grantee, class_name: "User"

end
