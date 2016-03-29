class Prescription < ActiveRecord::Base
  self.table_name   = 'prescription'
  self.primary_key  = 'prescriptionID'

  # 領藥範圍
  def drug_range
    doctorDate + 7.days
  end

  # 辨別是散客還是住民
  def identityCheck_text
    PrescriptionOfAll.find(self.prescriptionID).identityCheck == "fit" ? "散客" : "住民"
  end

  # 目前身分的姓名
  def identityCheckName
    if self.identityCheck_text == "散客"
      Fit.find(self.prescriptionID).name
    else
      Resident.find(self.prescriptionID).name
    end
  end

  # 處方箋電聯狀態
  def phoneStatus_text
    self.phoneStatus == true ? "有電聯":"未電聯"
  end

  # 處方箋取得狀態
  def obtainStatus_text
    self.obtainStatus == true ? "已取得":"未取得"
  end

  # 回傳醫院名稱
  def hospitalName
    Hospital.find(self.hospitalID).name
  end

end
