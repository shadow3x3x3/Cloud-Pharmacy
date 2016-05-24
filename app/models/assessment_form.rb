# AssessmentForm Model
class AssessmentForm < ActiveRecord::Base
  self.table_name   = 'assessment_form'
  self.primary_key  = 'afID'

  belongs_to :resident, foreign_key: 'residentID'

  has_one :af_prescription_content, foreign_key: 'prescriptionContentID',
                                    dependent: :destroy
  has_one :af_pharmacist_assess,    foreign_key: 'pharmacistAssessID',
                                    dependent: :destroy
  has_one :af_nurse_handling,       foreign_key: 'nurseHandlingID',
                                    dependent: :destroy
  has_many :drugs

  accepts_nested_attributes_for :af_prescription_content, :af_pharmacist_assess,
                                :af_nurse_handling,
                                allow_destroy: true, reject_if: :all_blank

  def process
    who = status
    if who == 'nurse'
      '護士處理中'
    elsif who == 'pharmacist'
      '藥師處理中'
    end
  end

  def process?(current_user_auth)
    who = status
    return true if who == current_user_auth
    false
  end

  def resident_name
    Resident.find(residentID).name
  end
end
