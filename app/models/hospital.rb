class Hospital < ActiveRecord::Base
    self.table_name   = 'hospital'
    self.primary_key  = 'hospitalID'

    validates_presence_of :name, :address, :isDrugID
end
