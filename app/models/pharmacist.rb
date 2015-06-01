class Pharmacist < ActiveRecord::Base
  self.table_name   = 'pharmacist'
  self.primary_key  = 'pharmacistID'

  validates_presence_of :name, :salary, :deliveryTimes
end
