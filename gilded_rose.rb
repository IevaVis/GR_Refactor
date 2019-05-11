require_relative 'item'

class GildedRose

  BRIE = "Aged Brie"
  BACKSTAGE = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  CONJURED = "Conjured"

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name != SULFURAS
        item.sell_in = item.sell_in - 1
      end
      case item.name

      when BACKSTAGE
        update_item_quality(item, 1)
        if item.sell_in < 10
          update_item_quality(item, 1)
        end
        if item.sell_in < 5
          update_item_quality(item, 1)
        end
          update_item_quality(item, -item.quality) if sell_in_expired?(item)

      when BRIE
        if item.quality < 50
          item.quality = item.quality + 1
        end
        update_item_quality(item, 1) if sell_in_expired?(item)

      when SULFURAS

      when CONJURED
        item.sell_in = item.sell_in - 1
        quality = item.quality - 2
        item.quality = quality if quality >= 0
      else
        update_item_quality(item, -1)
        update_item_quality(item, -1) if sell_in_expired?(item)
      end
    end
  end
end

def update_item_quality(item, quality_score)
  if item.quality > 0 and item.quality < 50
    item.quality += quality_score
  end
end

def decrease_item_sell_in_date(item)
  if item.name != SULFURAS
    item.sell_in -= 1
  end
end

def sell_in_expired?(item)
  item.sell_in < 0
end


