module DrugsHelper

  # 是否為慢性病用藥
  # @param  drug
  # @return 已取得 or 未取得
  def isChronic drug
    drug.isChronic == true ? "是慢性病用藥":"非慢性病用藥"
  end

end
