class AfPdf < Prawn::Document
  def initialize(assessmentForm, view)
    super()
    @assessmentForm = assessmentForm
    @view = view

    background_image cursor

  end

  def background_image y_position
    image_path = "#{Rails.root}/app/assets/images/post.png"
    image image_path, :at => [-22, y_position+30], :fit => [590, 830]
  end
end