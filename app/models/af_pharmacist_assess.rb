class AfPharmacistAssess < ActiveRecord::Base
  self.table_name   = "af_pharmacist_assess"
  self.primary_key  = "pharmacistAssessID"

  belongs_to :assessment_form, dependent: :destroy
end
