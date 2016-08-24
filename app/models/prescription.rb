# Prescription Model
class Prescription < ActiveRecord::Base
  self.table_name   = 'prescription'
  self.primary_key  = 'prescriptionID'

  belongs_to :fit
  belongs_to :resident
  has_one :delivery, foreign_key: 'prescriptionID'

  accepts_nested_attributes_for :delivery, allow_destroy: true, :reject_if => :all_blank

  has_attached_file :image,
                    styles: { medium: '600x600>', thumb: '100x100>' },
                    default_url: nil,
                    path: ':rails_root/public/prescriptions/:id/:style/:id.:extension',
                    url: '/prescriptions/:id/:style/:id.:extension'
  validates_attachment_presence :image
  validates_attachment_content_type :image,
                                    content_type: /\Aimage\/.*\z/

  def drug_range
    doctorDate + 7.days
  end

  def identity_check_text
    owner == 'fit' ? '散客' : '住民'
  end

  def identity_check_name
    if identity_check_text == '散客'
      Fit.find(ownerID).name
    else
      Resident.find(ownerID).name
    end
  end

  def phone_status_text
    phoneStatus == true ? '有電聯' : '未電聯'
  end

  def obtain_status_text
    obtainStatus == true ? '已送出' : '未處理'
  end

  def hospital_name
    Hospital.find(hospitalID).name
  end
end
