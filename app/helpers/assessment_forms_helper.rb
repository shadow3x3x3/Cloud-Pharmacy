module AssessmentFormsHelper

  def setup_af(assessmentForm)
    assessmentForm.build_af_prescription_content unless assessmentForm.af_prescription_content
    assessmentForm.build_af_pharmacist_assess    unless assessmentForm.af_pharmacist_assess
    assessmentForm.build_af_nurse_handling       unless assessmentForm.af_nurse_handling
    assessmentForm
  end

  def result_check ori_result, check_result
    ori_result.include?(check_result) if ori_result
  end
end
