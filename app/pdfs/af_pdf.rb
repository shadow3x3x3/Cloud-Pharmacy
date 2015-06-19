class AfPdf < Prawn::Document
  def initialize(assessmentForm, view)
    super()
    @assessmentForm = assessmentForm
    @view = view
    # background_image
    text "中文可以嗎"
  end

  def background_image
    image_path = "#{Rails.root}/app/assets/images/post.png"

  end
end