class CompetencyRole < ActiveRecord::Base

  belongs_to :competency
  belongs_to :role

end
