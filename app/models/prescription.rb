class Prescription < ActiveRecord::Base
  self.table_name   = 'prescription'
  self.primary_key  = 'prescriptionID'

  def drug_range
    doctorDate + 7.days 
  end

end
