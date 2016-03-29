class Resident < ActiveRecord::Base
  self.table_name   = 'resident'
  self.primary_key  = 'residentID'

  has_many :assessment_form, :foreign_key => "residentID"

  attr_accessor :age

  # 住民姓名
  def age
    Time.now.year - self.birthday.year
  end

  # 床號 - 住民
  def bedNumber_with_resident
    self.bedNumber.to_s + " - " + self.name.to_s
  end

  # 回傳機構名稱
  def agencyName
    Agency.find(self.agencyID).name
  end
end
