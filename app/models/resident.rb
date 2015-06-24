class Resident < ActiveRecord::Base
  self.table_name   = 'resident'
  self.primary_key  = 'residentID'

  attr_accessor :age

  def age
    Time.now.year - self.birthday.year
  end
end
