# Prescriptions Helper
module PrescriptionsHelper
  def setup_prescription(prescription)
    prescription.build_delivery unless prescription.delivery
    prescription
  end
end
