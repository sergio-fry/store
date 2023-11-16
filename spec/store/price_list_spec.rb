require "store/price_list"

module Store
  RSpec.describe PriceList do
    let(:goods) { PriceList.new(lines.split("\n")) }

    context do
      let(:lines) do
        <<~LINES
          Price#{' '}

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
  end
end
