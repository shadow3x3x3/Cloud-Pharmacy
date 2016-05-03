# Drug Model
class Drug < ActiveRecord::Base
  self.table_name   = 'drug'
  self.primary_key  = 'drugID'

  has_many :prescriptions, through: :prescription_of_drugs
end
