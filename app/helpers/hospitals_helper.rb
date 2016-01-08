module HospitalsHelper
  # 是否有藥品健保碼
  # @param  hospital
  # @return 有健保碼 or 無健保碼
  def isDrugID(hospital)
    hospital.isDrugID == true ? "有健保碼":"無健保碼"
  end
end
