module ApplicationHelper
  # 回傳醫院名稱
  # @param  hospitalID
  # @return hospital.name
  def hospitalName hospitalID
    Hospital.find(hospitalID).name
  end

  # 回傳藥師姓名
  # @param  hospitalID
  # @return hospital.name
  def pharmacistName pharmacistID
    Pharmacist.find(pharmacistID).name
  end

  # 回傳機構名稱
  # @param  agencyID
  # @return agency.name
  def agencyName agencyID
    Agency.find(agencyID).name
  end


end
