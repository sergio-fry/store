require "store/price_list"

module Store
  RSpec.describe PriceList do
    let(:goods) { PriceList.new(lines.split("\n")) }

    context do
      let(:lines) do
        <<~LINES
          +79151274685
                               🔥🔥🔥🔥🔥
           (Звоните принесём на павильон)


                      🍏Apple Technology🍏#{'      '}


          🇯🇵📱*SE 3 128⚪-40500
          🇯🇵📱*SE 3 128🔴-41000
        LINES
      end

      it { expect(goods.entries.size).to eq 2 }
      it { expect(goods.first.device).to eq "Apple Technology" }
      it { expect(goods.first.model).to eq "SE 3 128" }
      it { expect(goods.first.cost).to eq 40_500 }
    end

    context do
      let(:lines) do
        <<~LINES
                                💥iPhone 15💥

          🇯🇵📱*15P 256 Natural-131000

          🇯🇵📱*15PM 256🔵-142000

          🇯🇵📱*15PM 512⚫-163000
          🇯🇵📱*15PM 512🔵-163500
        LINES
      end

      it { expect(goods.entries.size).to eq 2 }
      it { expect(goods.first.device).to eq "iPhone 15" }
      it { expect(goods.first.model).to eq "15P 256 Natural" }
      it { expect(goods.first.cost).to eq 131000 }
    end
  end
end
