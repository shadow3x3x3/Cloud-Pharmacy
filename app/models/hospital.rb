class Hospital < ActiveRecord::Base
  self.table_name   = 'hospital'
  self.primary_key  = 'hospitalID'

  validates_presence_of :name, :address

  def isDrugID_text
    self.isDrugID == true ? "有健保碼":"無健保碼"
  end
end
