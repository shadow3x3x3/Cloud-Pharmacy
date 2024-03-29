class Agency < ActiveRecord::Base
  self.table_name   = 'agency'
  self.primary_key  = 'agencyID'

  validates_presence_of :name, :abbreviation, :phone, :fax, :address


  def pharmacistName
    Pharmacist.find(self.pharmacistID).name
  end
end
