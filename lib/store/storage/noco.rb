module Store
  module Storage
    class Noco
      def self.with_noco(host:, db:, auth:)
        uri = URI(host)
        Net::HTTP.start(uri.hostname, use_ssl: true) do |conn|
          yield new(
            conn:,
            auth:,
            db:
          )
        end
      end

      def initialize(conn:, auth:, db:)
        @conn = conn
        @auth = auth
        @db = db
      end

      def post(path, data)
        resp = @conn.post(
          "/api/v1/db/data/v1/#{@db}/#{path}",
          data.to_json,
          headers
        )
        case resp
        when Net::HTTPSuccess     # Any success class.
        else
          raise JSON.parse(resp.body)["msg"]
        end
      end

      def headers
        {
          'accept': "application/json",
          'Content-Type': "application/json",
          'xc-auth': @auth
        }
      end
    end
  end
end
