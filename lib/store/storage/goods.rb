# $ curl -X 'POST' \
#   'https://nocodb.host/api/v1/db/data/v1/pcmr09.../products' \
#   -H 'accept: application/json' \
#   -H 'Content-Type: application/json' \
#   -H 'xc-auth: eyJhbGciOiJIUzI...' \
#   -d '{
#   "Id": 0,
#   "Title": "string",
#   "provider": "string",
#   "type": "string",
#   "brand": "string",
#   "cost": 0
# }'

module Store
  module Storage
    class Goods
      def initialize(noco:)
        @noco = noco
      end

      def delete_all = @noco.bulk_delete("products/all", {})
      def update_all(attrs) = @noco.bulk_patch("products/all", attrs)

      def save(good)
        found = find(good.device, good.model)

        attrs = {
          Title: "#{good.device} #{good.model}",
          model: good.model,
          cost: good.cost,
          device: good.device,
          in_stock: true

        }

        if found.nil?
          @noco.post(
            :products, attrs
          )
        else
          @noco.patch(
            "products/#{found.id}",
            attrs
          )
        end
      end

      def find(device, model)
        data = @noco.get(
          "products/find-one", {
            fields: %w[Id model device cost].join(","),
            where: "(device,eq,#{device})~and(model,eq,#{model})"
          }
        )

        return if data[:Id].nil?

        Good.new(
          id: data[:Id],
          model: data[:model],
          device: data[:device],
          cost: data[:cost].to_i
        )
      end
    end
  end
end
