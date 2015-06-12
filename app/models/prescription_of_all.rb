class PrescriptionOfAll < ActiveRecord::Base
  self.table_name   = 'prescription_of_all'
  self.primary_key  = 'prescriptionID'
end
