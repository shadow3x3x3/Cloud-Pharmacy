module ApplicationHelper

  # 回傳醫院名稱
  # @param  hospitalID
  # @return hospital.name
  def hospitalName(hospitalID)
    Hospital.find(hospitalID).name
  end

  # 回傳機構名稱
  # @param  agencyID
  # @return agency.name
  def agencyName(agencyID)
    Agency.find(agencyID).name
  end

  # 回傳藥師姓名
  # @param  hospitalID
  # @return hospital.name
  def pharmacistName(pharmacistID)
    Pharmacist.find(pharmacistID).name
  end

  # 回傳住民姓名
  # @param  resident
  # @return resident.name
  def residentName(residentID)
    Resident.find(residentID).name
  end

  # 處理狀態
  def notification(current_user)
    afs = AssessmentForm.all.select("status").uniq
    !(afs.where(:status => current_user).empty?)
  end

end
