class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # validates_presence_of :name, :email, :phone, :idNumber



  # 找出對應的會員
  def memeber
    Member.find(self.id) if self.auth == 'customer'
  end

  # 回傳護士的評估表
  def nurse_af
    agencyID = Agency.find_by_name(self.name).id
    residents = Resident.where(:agencyID => agencyID).pluck(:residentID)
    assessmentForms = AssessmentForm.where(:residentID => residents)
  end

  # 處理狀態
  def notification
    if self.auth == 'nurse'
      afs = self.nurse_af
    else
      afs = AssessmentForm.all.select('status').uniq
    end
    !(afs.where(:status => self.auth).empty?)
  end

  # 回傳有哪些住民
  def residentsOfAgency
    agency_id = Agency.find_by_name(self.name)
    Resident.where(:agencyID => agency_id)
  end

end
