class AfPdf < Prawn::Document

  # 藥師評估結果對照表
  Result_hash_table = { 無特殊情形: [20, 393],
                        禁忌症或注意事項: [20, 376],
                        藥物不良反應: [20, 359],
                        服藥順從性不佳: [20, 342],

                        需藥物衛教或用藥資訊: [149, 393],
                        需監測藥物血中濃度: [149, 376],
                        不適當藥物治療處方: [149, 359],
                        有疾病未治療: [149, 342],

                        藥物交互作用: [278, 393],
                        重複同藥理作用或成份: [278, 376],
                        醫師處方過敏性藥物: [278, 359],
                        不符合健保使用規範: [278, 342],

                        需注意臨床症狀: [407, 393],
                        劑型劑量或頻率需調整: [407, 376],
                        有該使用而未併用藥物: [407, 359],
                        其他: [407, 342]
                      }.freeze

  def initialize(af, view)
    super()
    @assessment_form = af
    @view = view

    # 設定中文字型
    font "#{Rails.root}/app/pdfs/font/msyh.ttf"

    background_image(cursor)

    fill_resident_info(af)
    fill_prescription_content(af.afID)
    fill_pharmacist_assess(af.afID)
    fill_nurse_handling(af.afID)
  end

  # 設定背景
  def background_image(y_position)
    image_path = "#{Rails.root}/app/assets/images/post.png"
    image image_path, at: [-22, y_position + 30], fit: [590, 830]
  end

  # 填入住民基本資料
  def fill_resident_info(af)
    return unless af.af_prescription_content
    resident = Resident.find(af.residentID)

    # 姓名
    draw_text resident.name, at: [50, 665]
    # 年齡
    draw_text resident.age,  at: [200, 665]

    # 性別 - 依照身分證字號判斷
    if resident.residentIdNumber.slice(1) == '1'
      fill_blank(318, 672) # 男性
    else
      fill_blank(367, 672) # 女性
    end

    # 床號
    draw_text resident.bedNumber, :at => [450, 665]

    # 肝功能
    if af.afLiverFunction == '正常'
      fill_blank(60, 654) # 肝功能正常
    else
      fill_blank(99, 654) # 肝功能異常
    end

    # 腎功能
    if af.afKidneyFunction == '正常'
      fill_blank(189, 654) # 腎功能正常
    else
      fill_blank(228, 654) # 腎功能異常
    end

    # 用藥狀況
    case af.afDruguse
    when "需管灌"
      fill_blank(328, 654) # 需管灌
    when "需磨碎"
      fill_blank(382, 654) # 需磨碎
    when "可直接吞服固體"
      fill_blank(437, 654) # 可直接吞服固體
    end

    # 無過敏
    if af.allergyDrug.empty? && af.allergyFood.empty?
      fill_blank(60, 637) # 無過敏
    end

    # 過敏食物
    unless af.allergyFood.empty?
      fill_blank(84, 637) # 有食物過敏
      draw_text af.allergyFood, at: [220, 630]
    end

    # 過敏藥物
    unless af.allergyDrug.empty?
      fill_blank(307, 637) # 有藥品過敏
      draw_text af.allergyDrug, at: [445, 630]
    end

    # 參考附件
    case af.referenceAccessories
    when "生命徵象紀錄表"
      fill_blank(149, 619) # 生命徵象紀錄表
    when "檢驗數據"
      fill_blank(243, 619) # 檢驗數據
    when "護理紀錄"
      fill_blank(307, 619) # 護理紀錄
    when "醫囑"
      fill_blank(371, 619) # 醫囑
    when "其他"
      fill_blank(416, 619) # 其他
    end
  end

  # 填入處方資料
  def fill_prescription_content(prescriptionContentID)
    afPrescriptionContent = AfPrescriptionContent.find(prescriptionContentID)

    # 第一個處方內容
    # 醫院/科別
    hospital_and_division =
      afPrescriptionContent.hospitalName1 +
      ' / ' +
      afPrescriptionContent.division1

    draw_text hospital_and_division, at: [81, 576]
    # 看診日/天數
    doctorDate_and_days =
      afPrescriptionContent.doctorDate1.to_s +
      ' / ' +
      afPrescriptionContent.days1.to_s

    draw_text doctorDate_and_days, at: [88, 559]
    # 藥品
    write_drugs(1, afPrescriptionContent.afDrug1)

    # 第二個處方內容
    # 醫院/科別
    hospital_and_division =
      afPrescriptionContent.hospitalName2 +
      ' / ' +
      afPrescriptionContent.division2
    draw_text hospital_and_division, at: [252, 576]
    # 看診日/天數
    doctorDate_and_days =
      afPrescriptionContent.doctorDate2.to_s +
      ' / ' +
      afPrescriptionContent.days2.to_s
    draw_text doctorDate_and_days, at: [259, 559]
    # 藥品
    write_drugs(2, afPrescriptionContent.afDrug2)

    # 第三個處方內容
    # 醫院/科別
    hospital_and_division =
      afPrescriptionContent.hospitalName3 +
      ' / ' +
      afPrescriptionContent.division3
    draw_text hospital_and_division, at: [425, 576]
    # 看診日/天數
    doctorDate_and_days =
      afPrescriptionContent.doctorDate3.to_s +
      ' / ' +
      afPrescriptionContent.days3.to_s
    draw_text doctorDate_and_days, at: [432, 559]
    # 藥品
    write_drugs(3, afPrescriptionContent.afDrug3)
  end

  # 填入藥師評估結果
  def fill_pharmacist_assess(pharmacistAssessID)
    results_array = []

    afPharmacistAssess = AfPharmacistAssess.find(pharmacistAssessID)

    if afPharmacistAssess.assessmentResult
      result = afPharmacistAssess.assessmentResult.split(',')

      # 藥師評估結果
      result.each do |r|
        temp = Result_hash_table[r.to_sym] # 查詢result table去找要勾選的選項
        results_array << temp
      end

      results_array.each do |result_array|
        # binding.pry
        fill_blank(result_array[0], result_array[1]) unless result_array.nil? # 勾選被找到的result
      end
    end

    # 藥師建議內容
    draw_text afPharmacistAssess.suggestion, at: [25, 300]

    # 參考資料
    case afPharmacistAssess.referenceData
    when "仿單"
      fill_blank(70, 221) # 仿單
    when "藥物治療手冊"
      fill_blank(114, 221) # 藥物治療手冊
    end

    # 參考書籍
    case afPharmacistAssess.referenceBooks
    when 'Micromedex'
      fill_blank(114, 204) # Micromedex
    when 'PubMed'
      fill_blank(197, 204) # PudMed
    when 'UpToDate'
      fill_blank(261, 204) # UpToDate
    when '其他'
      fill_blank(332, 204) # 其他
    end

  end

  # 藥品欄位分行
  def write_drugs(postions, drugs_string)
    x = confirm_drug_x(postions)
    y = 536

    drugs = drugs_string.split /[\r\n]+/

    if drugs.size < 8
      drugs.each do |drug|
        size = drug.size > 20 ? 11 : 13
        draw_text drug, at: [x, y], size: size
        y -= 15
      end
    else
      y += 5
      drugs.each do |drug|
        size = drug.size > 25 ? 9 : 11
        draw_text drug, at: [x, y], size: size
        y -= 12
      end
    end
  end

  def confirm_drug_x(postions)
    case postions
    when 1
      20
    when 2
      195
    when 3
      370
    end
  end

  # 填入醫護人員處置方式
  def fill_nurse_handling(nurseHandlingID)
    afNurseHandling = AfNurseHandling.find(nurseHandlingID)

    # 填入處置方式
    case afNurseHandling.mode
    when '持續觀察住民臨床症狀'
      fill_blank(20, 151) # 藥師用藥，觀察臨床
    when '持續觀察住民是否有藥物引發之副作用'
      fill_blank(20, 134) # 藥師用藥，藥物之副作用
    when '照會醫師'
      fill_blank(20, 117) # 藥師建議內容
      doctor_handling(afNurseHandling)
    when '其他'
      fill_blank(20, 65) # 其他處置
    end

    # 填入住民療效追蹤
    draw_text afNurseHandling.residentFollow, at: [30, 27]
  end

  # 照會醫師處理
  def doctor_handling(afNurseHandling)
    if afNurseHandling.doctorDo == '醫師接受藥師建議'
      fill_blank(35, 100) # 醫師接受藥師建議
    else
      fill_blank(35, 82) # 醫師未接受建議
    end
  end

  # 填框框
  def fill_blank(x, y)
    rectangle [x, y], 9, 9
    fill
  end
end
