class AfPdf < Prawn::Document
  def initialize(assessmentForm, view)
    super()
    @assessmentForm = assessmentForm
    @view = view
    text "hell world"

  end

  def background_image

  end
end