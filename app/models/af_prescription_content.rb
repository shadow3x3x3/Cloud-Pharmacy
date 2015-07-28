class AfPrescriptionContent < ActiveRecord::Base
  self.table_name   = "af_prescription_content"
  self.primary_key  = "prescriptionContentID"

  belongs_to :assessment_form
end

