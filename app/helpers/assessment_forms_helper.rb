module AssessmentFormsHelper
  def setup_af(af)
    af.build_af_prescription_content unless af.af_prescription_content
    af.build_af_pharmacist_assess    unless af.af_pharmacist_assess
    af.build_af_nurse_handling       unless af.af_nurse_handling
    af
  end

  def result_check(ori_result, check_result)
    ori_result.include?(check_result) if ori_result
  end

  def auth_of_form
    current_user.auth
  end
end
