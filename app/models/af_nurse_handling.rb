class AfNurseHandling < ActiveRecord::Base
  self.table_name   = "af_nurse_handling"
  self.primary_key  = "nurseHandlingID"

  belongs_to :assessment_form, :dependent => :destroy
end
