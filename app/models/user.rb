# User Model
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # validates_presence_of :name, :email, :phone, :idNumber

  def member
    Member.find(id) if auth == 'customer'
  end

  def nurse_af
    agency_id = Agency.find_by_name(name).id
    residents = Resident.where(agencyID: agency_id).pluck(:residentID)
    AssessmentForm.where(residentID: residents)
  end

  # process status
  def notification
    afs =
      if auth == 'nurse'
        nurse_af
      else
        AssessmentForm.all.select('status').uniq
      end
    !afs.where(status: auth).empty?
  end

  def residents_of_agency
    agency_id = Agency.find_by_name(name)
    Resident.where(agencyID: agency_id)
  end
end
