class AssessmentForm < ActiveRecord::Base
  self.table_name   = "assessment_form"
  self.primary_key  = "afID"

  belongs_to :resident, :foreign_key => "residentID"

  has_one :af_prescription_content, :foreign_key => "prescriptionContentID"
  has_one :af_pharmacist_assess,    :foreign_key => "pharmacistAssessID"
  has_one :af_nurse_handling,       :foreign_key => "nurseHandlingID"

  accepts_nested_attributes_for :af_prescription_content, :af_pharmacist_assess, :af_nurse_handling,
                                :allow_destroy => true, :reject_if => :all_blank

  def process
    who = self.status
    if who == "nurse"
      "護士處理中"
    elsif who == "pharmacist"
      "藥師處理中"
    end
  end
end
