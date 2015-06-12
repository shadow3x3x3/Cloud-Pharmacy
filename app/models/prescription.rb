class Prescription < ActiveRecord::Base
  self.table_name   = 'prescription'
  self.primary_key  = 'prescriptionID'
end
