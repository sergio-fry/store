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

      def save(good)
        @noco.post(
          :products, {
            "Title": "#{good.device} #{good.model}",
            "model": good.model,
            "cost": good.cost,
            "device": good.device
          }
        )
      end
    end
  end
end
