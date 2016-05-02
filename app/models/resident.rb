# Redisent Model
class Resident < ActiveRecord::Base
  self.table_name   = 'resident'
  self.primary_key  = 'residentID'

  has_many :assessment_form, foreign_key: 'residentID'
  has_many :prescription, -> { where(owner: 'resident') },
           foreign_key: 'ownerID'

  attr_accessor :age

  # resident Name
  def age
    Time.now.year - birthday.year
  end

  def bednumber_with_resident
    bedNumber.to_s + ' - ' + name.to_s
  end

  def agency_name
    Agency.find(agencyID).name
  end
end
