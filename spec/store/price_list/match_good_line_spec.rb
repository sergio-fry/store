require "store/price_list"
require "store/price_list/matched_good_line"

module Store
  class PriceList
    RSpec.describe MatchedGoodLine do
      def line(text) = described_class.new(text)

      it { expect(line("iphone -100").model).to eq "iphone" }
      it { expect(line("iphone -100").cost).to eq "100" }
    end
  end
end