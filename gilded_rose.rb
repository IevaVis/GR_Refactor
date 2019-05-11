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
      decrease_sell_in_date_by_one(item) if item.name != SULFURAS
      case item.name
      when SULFURAS
      when BACKSTAGE
        increase_item_quality(item)
        if item.sell_in < 10
          increase_item_quality(item)
        end
        if item.sell_in < 5
          increase_item_quality(item)
        end
          decrease_item_quality(item, -item.quality) if sell_in_expired?(item)
      when BRIE
        increase_item_quality(item)
        increase_item_quality(item) if sell_in_expired?(item)
      when CONJURED
        decrease_item_quality(item, -2)
      else
        decrease_item_quality(item, -1)
        decrease_item_quality(item, -1) if sell_in_expired?(item)
      end
    end
  end
end

def decrease_item_quality(item, quality_score)
  if item.quality > 0
    item.quality += quality_score
  end
end

def increase_item_quality(item)
  if item.quality < 50
    item.quality += 1
  end
end

def sell_in_expired?(item)
  item.sell_in < 0
end

def decrease_sell_in_date_by_one(item)
  item.sell_in = item.sell_in - 1
end


