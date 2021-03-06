require File.join(File.dirname(__FILE__), 'gilded_rose')


describe Item.new 'Foo', 0, 0 do 
   it { is_expected.to have_attributes(name: 'Foo') } 
   it { is_expected.to have_attributes(sell_in: 0) }
   it { is_expected.to have_attributes(quality: 0) }

   context "with invalid input" do
      it "throws an argument error when not given a type argument" do
        expect { Item.new }.to raise_error(ArgumentError)
      end
    end
end


describe 'Item' do
  let(:newItem){Item.new :name, :sell_in, :quality}
  context "initialize" do
    it "has name" do
      expect{newItem.name}.to_not raise_error
    end

    it "has sell_in" do
      expect{newItem.sell_in}.to_not raise_error
    end

    it "has quality" do
      expect{newItem.quality}.to_not raise_error
    end
  end
end

describe GildedRose do
  it "is available as described_class" do
    expect(described_class).to eq(GildedRose)
  end
end

describe GildedRose do
  describe '#update_quality' do
    shared_examples 'item sell value' do |item_name|
      it 'lowers sell in value by 1 at the end of the day' do
        item = Item.new(item_name, 1, 0)
        items = [item]
        gilded_rose = GildedRose.new(items)
        gilded_rose.update_quality
        expect(item.sell_in).to eq 0
      end

      it 'sell in value can be negative' do
        item = Item.new(item_name, 0, 0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality

        expect(item.sell_in).to eq -1
      end
    end
  
    shared_examples 'quality value' do |item_name|
      it 'quality value is never negative' do
        item = Item.new(item_name, 0, 0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality
        expect(item.quality).to eq 0
      end

      it 'quality value is never more than 50' do
        item = Item.new(item_name, 10, 50)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality
        expect(item.quality).to be <= 50
      end
    end

    context 'item name' do
      it 'does not change the name' do
        items = [Item.new('foo', 0, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].name).to eq 'foo'
      end
    end
  
    context 'when sell in date not passed yet' do
        it 'lowers quality value by 1 at the end of the day' do
          item = Item.new('foo', sell_in=1, quality=1)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality

          expect(item.quality).to eq 0
        end
    
    context 'when item is Sulfuras' do
      it 'does not change the sell in' do
        item = Item.new('Sulfuras, Hand of Ragnaros', 0, 0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality
        expect(item.sell_in).to eql 0
      end
    end

    context 'Sulfuras quality' do
      it_behaves_like 'quality value', item_name='Sulfuras, Hand of Ragnaros'

      it 'should not change sell in' do
        item = Item.new('Sulfuras, Hand of Ragnaros', 0, 0)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality
        expect(item.sell_in).to eql 0
      end

      it 'does not change the quality' do
        item = Item.new('Sulfuras, Hand of Ragnaros', 0, 80)
        items = [item]
        gilded_rose = described_class.new(items)
        gilded_rose.update_quality
        expect(item.quality).to eql 80
      end
    end

    context 'when item is Backstage passes to a TAFKAL80ETC concert' do 
      it_behaves_like 'item sell value', item_name = 'Backstage passes to a TAFKAL80ETC concert'
      context 'Backstage quality' do
        it_behaves_like 'quality value', item_name='Backstage passes to a TAFKAL80ETC concert'
      end
      context 'when sell in date not passed yet' do
          context 'when sell in above 10 days' do
            it 'increases by 1 the older it gets' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 1)
              items = [item]
              gilded_rose = described_class.new(items)
              update = 5
              update.times { gilded_rose.update_quality }
              expect(item.quality).to eq (1 + update)
            end
          end
            it 'increases to 50 when sell_in above 10 and quality is 49' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality
              expect(item.quality).to eq 50
            end

            it 'increases to 50 instead of 51 when sell_in at least 5 and quality is 49' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality
              expect(item.quality).to eq 50
          end
        end
        context 'when sell in 10 days or less and above 5 days' do
          it 'increases by 2 the older it gets' do
            item = Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10)
            items = [item]
            gilded_rose = described_class.new(items)
            update = 5
            update.times { gilded_rose.update_quality }
            expect(item.quality).to eq (10 + (2 * update))
          end

          it 'increases to 50 instead of 52 when sell_in at least 1 and quality is 49' do
            item = Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 49)
              items = [item]
            gilded_rose = described_class.new(items)
            gilded_rose.update_quality
            expect(item.quality).to eq 50
            end
          end
          context 'when sell in 5 days or less' do
            it 'increases by 3 the older it gets' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 1)
              items = [item]
              gilded_rose = described_class.new(items)
              update = 5
              update.times { gilded_rose.update_quality }
              expect(item.quality).to eq (1 + (3 * update))
            end

            it 'increases to 50 instead of 52 when sell_in at least 1 and quality is 49' do
              item = Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 49)
              items = [item]
              gilded_rose = described_class.new(items)
              gilded_rose.update_quality
              expect(item.quality).to eq 50
            end
          end

        context 'when sell in date has passed' do
          it 'drops to 0 after the concert' do
            item = Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 5)
            items = [item]
            gilded_rose = described_class.new(items)
            gilded_rose.update_quality
            expect(item.quality).to eq 0
          end
        end
      end

    context 'when item is Aged Brie' do
      it_behaves_like 'item sell value', item_name = 'Aged Brie'
      
      context 'item quality' do
        context 'when sell in date not passed yet' do
          it 'increases by 1 the older it gets' do
            item = Item.new('Aged Brie', 2, 0)
            items = [item]
            gilded_rose = described_class.new(items)
            gilded_rose.update_quality
            expect(item.quality).to eq 1
          end
        end

      context 'when sell in date has passed' do
        it 'increases twice as fast the older it gets' do
          update = 5
          item = Item.new('Aged Brie', 0, 0)
          items = [item]
          gilded_rose = described_class.new(items)
          update.times do |i|
            gilded_rose.update_quality
            expect(item.quality).to eq (2 * (i + 1))
          end
          expect(item.quality).to eq (2 * update)
        end
      end

        it 'is never more than 50' do
          item = Item.new('Aged Brie', 2, 49)
          items = [item]
          gilded_rose = described_class.new(items)
          2.times do
            gilded_rose.update_quality
          end
          expect(item.quality).to eq 50
        end
      end
    end

    context 'when item is Conjured' do
      it_behaves_like 'item sell value', item_name = 'Conjured'
      it_behaves_like 'quality value', item_name='Conjured'
      it 'lowers quality value by 2 at the end of the day' do
          item = Item.new('Conjured', 1, 2)
          items = [item]
          gilded_rose = described_class.new(items)
          gilded_rose.update_quality
          expect(item.quality).to eq 0
        end
      end
    end
  end
end 








