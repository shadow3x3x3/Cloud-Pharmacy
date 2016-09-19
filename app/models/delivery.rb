# Delivery Model
class Delivery < ActiveRecord::Base
  self.table_name   = 'delivery'
  self.primary_key  = 'deliveryID'

  belongs_to :prescription
end
