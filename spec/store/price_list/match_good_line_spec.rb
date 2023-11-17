require "store/price_list"
require "store/price_list/matched_good_line"

module Store
  class PriceList
    RSpec.describe MatchedGoodLine do
      def line(text) = described_class.new(text)

      it { expect(line("iphone -100").model).to eq "iphone" }
      it { expect(line("iphone -100").cost).to eq "100" }
      it { expect(line("AppleWatch USB-C (AAA)-100").cost).to eq "100" }
      it { expect(line("AppleWatch USB-C (AAA)-100").model).to eq "AppleWatch USB-C (AAA)" }

      it {
        expect(
          line(
            "iphone⚫  ⚫️ -2200"
          ).cost
        ).to eq "2200"
      }

      it {
        expect(
          line(
            "iphone⚫  ⚫️ -2200"
          ).color
        ).to eq "black"
      }

      it {
        expect(
          line(
            "iphone⚫  ⚫️ -2200"
          ).model
        ).to eq "iphone"
      }
    end
  end
end
