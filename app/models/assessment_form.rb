class AssessmentForm < ActiveRecord::Base
  self.table_name   = "assessment_form"
  self.primary_key  = "afID"

  has_one :af_prescription_content, :foreign_key => "prescriptionContentID"
  has_one :af_pharmacist_assess,    :foreign_key => "pharmacistAssessID"
  has_one :af_nurse_handling,       :foreign_key => "nurseHandlingID"

  accepts_nested_attributes_for :af_prescription_content, :af_pharmacist_assess, :af_nurse_handling,
                                :allow_destroy => true, :reject_if => :all_blank
end

