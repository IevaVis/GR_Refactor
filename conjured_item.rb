class ConjuredItem < Item
  private

  def update_quality
    quality = item.quality - 2
    item.quality = quality if quality >= 0
  end

  def update_sell_in
    item.sell_in -= 1
  end
end