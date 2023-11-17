require "store/storage/noco"
require "store/storage/goods"
require "store/good"

module Store
  module Storage
    RSpec.describe Goods, skip: true do
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

      describe "good save" do
        let(:new_good) { Good.new(model: "13", device: "iphone", cost: 100, color: "black") }
        let(:found) { goods.find_by("iphone", "13", "black") }

        before { goods.save(new_good) }

        it { expect(found.device).to eq "iphone" }
        it { expect(found.model).to eq "13" }
      end

      describe "update_all" do
        let(:new_good) { Good.new(model: "13", device: "iphone", cost: 100, color: "black") }

        attr_reader :id

        before { @id = goods.save(new_good)[:Id] }

        def found
          goods.find(id)
        end

        example do
          goods.update_all({ in_stock: false }, condition: "(UpdatedAt,lt,today)")
        end
      end
    end
  end
end
