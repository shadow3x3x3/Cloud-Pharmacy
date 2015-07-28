class Fit < ActiveRecord::Base
  self.table_name   = 'fit'
  self.primary_key  = 'fitID'

  belongs_to :user, :foreign_key => "fitID"
end
