require "store/storage/noco"
require "store/storage/goods"
require "store/good"

module Store
  module Storage
    RSpec.describe Goods, skip: "debug only" do
      attr_reader :goods

      around do |example|
        Store::Storage::Noco.with_noco(
          host: ENV.fetch("NOCODB_HOST"),
          db: ENV.fetch("NOCODB_DB"),
          auth: ENV.fetch("NOCODB_AUTH_TOKEN")
        ) do |noco|
          @goods = described_class.new(
            noco:
          )

          example.run
        end
      end

      let(:new_good) { Good.new(model: "13", device: "iphone", cost: 100, color: "black") }
      let(:found) { goods.find("iphone", "13", "black") }

      before { goods.save(new_good) }

      it { expect(found.device).to eq "iphone" }
      it { expect(found.model).to eq "13" }
    end
  end
end
