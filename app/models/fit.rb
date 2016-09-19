# Fit Model
class Fit < ActiveRecord::Base
  self.table_name   = 'fit'
  self.primary_key  = 'fitID'

  belongs_to :member
  has_many :prescription, -> { where(owner: 'fit') },
           foreign_key: 'ownerID'
end
