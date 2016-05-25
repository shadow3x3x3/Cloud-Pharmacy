# Drug Model
class Drug < ActiveRecord::Base
  self.table_name   = 'drug'
  self.primary_key  = 'drugID'

  has_many :assessmentForms
end
