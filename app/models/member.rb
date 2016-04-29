# Member Model
class Member < ActiveRecord::Base
  self.table_name   = 'member'
  self.primary_key  = 'memberID'

  has_many :fits

  def fits
    fits_id = FitOfMember.where(memberID: id).pluck(:fitID)
    Fit.find(fits_id)
  end
end
