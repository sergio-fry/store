require "store/price_list"

module Store
  RSpec.describe PriceList do
    let(:goods) { PriceList.new(lines.split("\n")) }

    context do
      let(:lines) do
        <<~LINES
                      *Apple Technology*

          🇯🇵📱*SE 3 128⚪-40500
        LINES
      end

      it { expect(goods.entries.size).to eq 1 }
      it { expect(goods.first.device).to eq "Apple Technology" }
      it { expect(goods.first.model).to eq "SE 3 128" }
      it { expect(goods.first.cost).to eq 40_500 }
      it { expect(goods.first.color).to eq "white" }
    end

    context do
      let(:lines) do
        <<~LINES
                                💥iPhone 15💥
          🇯🇵📱*15P 256 Natural-131000
        LINES
      end

      it { expect(goods.entries.size).to eq 1 }
      it { expect(goods.first.device).to eq "iPhone 15" }
      it { expect(goods.first.model).to eq "15P 256" }
      it { expect(goods.first.cost).to eq 131_000 }
    end

    context do
      let(:lines) do
        <<~LINES
                                      💥Apple💥

          Pencil 2-10500
        LINES
      end

      it { expect(goods.entries.size).to eq 1 }
      it { expect(goods.first.device).to eq "Apple" }
      it { expect(goods.first.model).to eq "Pencil 2" }
      it { expect(goods.first.cost).to eq 10_500 }
    end
  end
end
