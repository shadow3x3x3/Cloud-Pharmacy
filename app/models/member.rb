class Member < ActiveRecord::Base
  self.table_name   = 'member'
  self.primary_key  = 'memberID'

  has_many :fits
end
