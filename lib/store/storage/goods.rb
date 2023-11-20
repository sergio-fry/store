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

      def update_all(attrs, condition: nil)
        @noco.bulk_patch("products/all", attrs, condition:)
      end

      def save(good)
        found = find_by(good.device, good.model, good.color)

        if found.nil?
          @noco.post(
            :products, attrs_from_record(good)
          )
        else
          return attrs_from_record(found) if changed_attrs(found, good).empty?

          @noco.patch(
            "products/#{found.id}",
            changed_attrs(found, good)
          )
        end
      end

      def changed_attrs(old, current)
        Hash[attrs_from_record(current).to_a -
             attrs_from_record(old).to_a]
      end

      def attrs_from_record(record)
        {
          Title: "#{record.device} #{record.model}",
          model: record.model,
          cost: record.cost,
          color: record.color,
          device: record.device,
          in_stock: record.in_stock
        }
      end

      def where_condition(attrs)
        attrs.map do |name, value|
          "(#{name},eq,#{value})"
        end.join("~and")
      end

      def find(id)
        object_from_attrs @noco.get(
          "products/#{id}"
        )
      end

      def find_by(device, model, color)
        object_from_attrs @noco.get(
          "products/find-one", {
            where: color ? where_condition(device:, model:, color:) : where_condition(device:, model:)
          }
        )
      end

      def object_from_attrs(attrs)
        return if attrs[:Id].nil?

        Good.new(
          id: attrs[:Id],
          model: attrs[:model],
          device: attrs[:device],
          cost: attrs[:cost].to_i,
          color: attrs[:color],
          in_stock: attrs[:in_stock]
        )
      end
    end
  end
end
