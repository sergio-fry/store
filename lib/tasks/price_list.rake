namespace :price_list do
  desc "parse input text"
  task parse: :environment do
    include ActiveSupport::NumberHelper
    require "store/price_list"

    Store::PriceList.new(
      File.open(Rails.root.join("tmp/price.txt")).read.lines
    ).uniq(&:model).each do |good|
      puts "#{good.device} #{good.model} - #{number_to_delimited(good.cost)} руб."
    end
  end

  desc "import price list"
  task import: :environment do
    require "store/price_list"
    require "store/storage/goods"

    Store::Storage::Noco.with_noco(
      host: ENV.fetch("NOCODB_HOST"),
      db: ENV.fetch("NOCODB_DB"),
      auth: ENV.fetch("NOCODB_AUTH_TOKEN")
    ) do |noco|
      goods = Store::Storage::Goods.new(
        noco:
      )

      #goods.delete_all

      # TODO: change on stock when missing only
      goods.update_all({ in_stock: false })

      Store::PriceList.new(
        File.open(Rails.root.join("import/mobilochka.txt")).read.lines
      ).each do |good|
        good.in_stock = true
        goods.save(good)
      end

      # goods.update_all({ in_stock: false }, condition: "(UpdatedAt,lt,today)")
    end
  end
end
