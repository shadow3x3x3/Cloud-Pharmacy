module PrescriptionsHelper

  # 辨別是散客還是住民
  # @param  prescription
  # @return "散客" or "住民"
  def identityCheck(prescription)
    PrescriptionOfAll.find(prescription.prescriptionID).identityCheck == "fit" ? "散客" : "住民"
  end

  # 目前身分的姓名
  # @param  prescription
  # @return 散客姓名 or 住民姓名
  def identityCheckName(prescription)
    if identityCheck(prescription) == "散客"
      Fit.find(prescription.prescriptionID).name
    else
      Resident.find(prescription.prescriptionID).name
    end
  end

  # 處方箋電聯狀態
  # @param  prescription
  # @return 有電聯 or 未電聯
  def phoneStatus(prescription)
    prescription.phoneStatus == true ? "有電聯":"未電聯"
  end

  # 處方箋取得狀態
  # @param  prescription
  # @return 已取得 or 未取得
  def obtainStatus(prescription)
    prescription.obtainStatus == true ? "已取得":"未取得"
  end
end
