class Member < ActiveRecord::Base
  self.table_name   = 'member'
  self.primary_key  = 'memberID'

  validates_presence_of :memberID, :memberIdNumber, :email, :name,
                        :phone,    :password

  validates_format_of :phone, :with => /[0-9]*/

  has_secure_password

end
