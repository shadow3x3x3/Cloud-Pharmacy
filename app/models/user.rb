class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # validates_presence_of :name, :email, :phone, :idNumber

  has_many :fits

  def nurse_af
    agencyID = Agency.find_by_name(self.name).id
    residents = Resident.where(:agencyID => agencyID).pluck(:residentID)
    assessmentForms = AssessmentForm.where(:residentID => residents)
  end

  # 處理狀態
  def notification
    if self.auth == "nurse"
      afs = self.nurse_af
    else
      afs = AssessmentForm.all.select("status").uniq
    end
    !(afs.where(:status => self.auth).empty?)
  end

end
