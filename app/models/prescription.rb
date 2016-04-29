# Prescription Model
class Prescription < ActiveRecord::Base
  self.table_name   = 'prescription'
  self.primary_key  = 'prescriptionID'

  belongs_to :fit
  belongs_to :resident

  def drug_range
    doctorDate + 7.days
  end

  def identity_check_text
    PrescriptionOfAll.find(prescriptionID).identityCheck == 'fit' ? "散客" : "住民"
  end

  def identity_check_name
    if identity_check_text == '散客'
      Fit.find(prescriptionID).name
    else
      Resident.find(prescriptionID).name
    end
  end

  def phone_status_text
    phoneStatus == true ? '有電聯' : '未電聯'
  end

  def obtain_status_text
    obtainStatus == true ? '已取得' : '未取得'
  end

  def hospital_name
    Hospital.find(hospitalID).name
  end
end
