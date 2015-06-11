class Member < ActiveRecord::Base
  self.table_name   = 'member'
  self.primary_key  = 'memberID'

  validates_format_of :phone, :with => /[0-9]*/

  has_secure_password

end
