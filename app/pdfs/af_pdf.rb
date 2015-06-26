class AfPdf < Prawn::Document

  Result_hash_table = {
                        無特殊情形:[20, 393],
                        禁忌症或注意事項:[20, 376],
                        藥物不良反應:[20, 359],
                        服藥順從性不佳:[20, 342],

                        需藥物衛教或用藥資訊:[149, 393],
                        需監測藥物血中濃度:[149, 376],
                        不適當藥物治療處方:[149, 359],
                        有疾病未治療:[149, 342],

                        藥物交互作用:[278, 393],
                        重複同藥理作用或成分:[278, 376],
                        醫師處方過敏性藥物:[278, 359],
                        不符合健保使用規範:[278, 342],

                        需注意臨床症狀:[407, 393],
                        劑型劑量或頻率需調整:[407, 376],
                        有該使用而未併用藥物:[407, 359],
                        其他:[407, 342]
                      }

  def initialize(assessmentForm, view)
    super()
    @assessmentForm = assessmentForm
    @view = view

    # 設定中文字型
    font "#{Rails.root}/app/pdfs/font/msyh.ttf"

    background_image cursor

    fill_resident_info assessmentForm
    fill_prescription_content assessmentForm.prescriptionContentID
    fill_pharmacist_assess assessmentForm.pharmacistAssessID

    # 藥師建議內容
    draw_text "test", :at => [25, 300]
    # 參考資料
    fill_blank(70, 221) # 仿單
    fill_blank(114, 221) # 藥物治療手冊
    # 參考書籍
    fill_blank(114, 204) # Micromedex
    fill_blank(197, 204) # PudMed
    fill_blank(261, 204) # UpToDate
    fill_blank(332, 204) # 其他

    fill_blank(35, 100) # 醫師接受藥師建議
    fill_blank(35, 82) # 醫師未接受建議

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
    else
      fill_blank(367, 672) # 女性
    end
    # 床號
    draw_text resident.bedNumber, :at => [450, 665]
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
      draw_text assessmentForm.allergyFood, :at => [220, 630]
    end
    # 過敏藥物
    if assessmentForm.allergyDrug
      fill_blank(307, 637) # 有藥品過敏
      draw_text assessmentForm.allergyFood, :at => [445, 630]
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

  # 填入處方箋資料
  def fill_prescription_content prescriptionContentID
    afPrescriptionContent = AfPrescriptionContent.find(prescriptionContentID)

    # 第一個處方內容
    # 醫院/科別
    hospital_and_division =
      afPrescriptionContent.hospitalName1 + " / " + afPrescriptionContent.division1
    draw_text hospital_and_division, :at => [81, 576]
    # 看診日/天數
    doctorDate_and_days =
      afPrescriptionContent.doctorDate1.to_s + " / " + afPrescriptionContent.days1.to_s
    draw_text doctorDate_and_days, :at => [88, 559]
    # 備註
    draw_text afPrescriptionContent.remark1, :at => [25, 536]

    # 第二個處方內容
    # 醫院/科別
    hospital_and_division =
      afPrescriptionContent.hospitalName2 + " / " + afPrescriptionContent.division2
    draw_text hospital_and_division, :at => [252, 576]
    # 看診日/天數
    doctorDate_and_days =
      afPrescriptionContent.doctorDate2.to_s + " / " + afPrescriptionContent.days2.to_s
    draw_text doctorDate_and_days, :at => [259, 559]
    # 備註
    draw_text afPrescriptionContent.remark2, :at => [200, 536]

    # 第三個處方內容
    # 醫院/科別
    hospital_and_division =
      afPrescriptionContent.hospitalName3 + " / " + afPrescriptionContent.division3
    draw_text hospital_and_division, :at => [425, 576]
    # 看診日/天數
    doctorDate_and_days =
      afPrescriptionContent.doctorDate3.to_s + " / " + afPrescriptionContent.days3.to_s
    draw_text doctorDate_and_days, :at => [432, 559]
    # 備註
    draw_text afPrescriptionContent.remark3, :at => [375, 536]
  end

  # 填入藥師評估結果
  def fill_pharmacist_assess pharmacistAssessID
    result_array = []

    afPharmacistAssess = AfPharmacistAssess.find(pharmacistAssessID)
    result = afPharmacistAssess.assessmentResult.split(',')

    # 藥師評估結果
    result.each do |result|
      temp = Result_hash_table[result.to_sym]
      result_array << temp
    end

    result_array.each do |result_array|
      fill_blank(result_array[0], result_array[1])
    end


  end

  # 填框框
  def fill_blank x, y
    rectangle [x, y], 9, 9
    fill
  end

end