class PrescriptionOfDrug < ActiveRecord::Base
  self.table_name   = 'prescription_of_drug'

  def drugOriName
    Drug.find(drugID).oriName
  end

  def drugChiName
    Drug.find(drugID).chiName
  end
end
