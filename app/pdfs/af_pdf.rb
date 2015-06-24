class AfPdf < Prawn::Document
  def initialize(assessmentForm, view)
    super()
    @assessmentForm = assessmentForm
    @view = view

    # 設定中文字型
    font "#{Rails.root}/app/pdfs/font/msyh.ttf"

    background_image cursor

    fill_resident_info assessmentForm

    fill_blank(35, 100) # 醫師接受藥師建議
    fill_blank(35,82) # 醫師未接受建議

    # draw_text Resident.find(assessmentForm.residentID).name, :at => [20, 530] # 第一個備註

  end

  # 設定背景
  def background_image y_position
    image_path = "#{Rails.root}/app/assets/images/post.png"
    image image_path, :at => [-22, y_position+30], :fit => [590, 830]
  end

  # 填入住民基本資料
  def fill_resident_info assessmentForm
    resident = Resident.find(assessmentForm.residentID)

    # 姓名
    draw_text resident.name, :at => [50, 665]
    # 年齡
    draw_text resident.age,  :at => [200, 665]
    # 性別 - 依照身分證字號判斷
    if resident.residentIdNumber.slice(1) == "1"
      fill_blank(318, 672) # 男性
      fill
    else
      fill_blank(367, 672) # 女性
      fill
    end
    # 床號
    draw_text resident.bedNumber,  :at => [450, 665]
    # 肝功能
    if assessmentForm.afLiverFunction == "正常"
      fill_blank(60, 654) # 肝功能正常
    else
      fill_blank(99, 654) # 肝功能異常
    end
    # 腎功能
    if assessmentForm.afKidneyFunction == "正常"
      fill_blank(189, 654) # 腎功能正常
    else
      fill_blank(228, 654) # 腎功能異常
    end
    # 用藥狀況
    case assessmentForm.afDruguse
    when "需管灌"
      fill_blank(328, 654) # 需管灌
    when "需磨碎"
      fill_blank(382, 654) # 需磨碎
    when "可直接吞服固體"
      fill_blank(437, 654) # 可直接吞服固體
    end

    # 無過敏
    if !(assessmentForm.allergyDrug && assessmentForm.allergyFood)
      fill_blank(60, 637) # 無過敏
    end
    # 過敏食物
    if assessmentForm.allergyFood
      fill_blank(84, 637) # 有食物過敏
      draw_text "過敏食物",  :at => [220, 630]
    end
    # 過敏藥物
    if assessmentForm.allergyDrug
      fill_blank(307, 637) # 有藥品過敏
      draw_text "過敏食物",  :at => [445, 630]
    end

    # 參考附件
    case assessmentForm.referenceAccessories
    when "生命徵象紀錄表"
      fill_blank(149, 619) # 生命徵象紀錄表
    when "檢驗數據"
      fill_blank(243, 619) # 檢驗數據
    when "護理記錄"
      fill_blank(307, 619) # 護理記錄
    when "醫囑"
      fill_blank(371, 619) # 醫囑
    when "其他"
      fill_blank(416, 619) # 其他
    end


  end

  def fill_blank x, y
    rectangle [x, y], 9, 9
    fill
  end

end