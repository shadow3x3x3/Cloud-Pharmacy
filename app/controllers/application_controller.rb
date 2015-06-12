class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :identityCheck

  # 辨別是散客還是住民
  # @param  prescription
  # @return "散客" or "住民"
  def identityCheck prescription
    PrescriptionOfAll.find(prescription.prescriptionID).identityCheck == "fit" ? "散客" : "住民"
  end

end
