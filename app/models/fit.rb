class Fit < ActiveRecord::Base
  self.table_name   = 'fit'
  self.primary_key  = 'fitID'

  belongs_to :member
end
