# Fit Model
class Fit < ActiveRecord::Base
  self.table_name   = 'fit'
  self.primary_key  = 'fitID'

  has_many :prescription
  belongs_to :member
end
