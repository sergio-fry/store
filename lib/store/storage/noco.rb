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

      def bulk_delete(path, data)
        request(
          :delete,
          "/api/v1/db/data/bulk/v1/#{@db}/#{path}",
          data
        )
      end

      def bulk_patch(path, data)
        request(
          :patch,
          "/api/v1/db/data/bulk/v1/#{@db}/#{path}",
          data
        )
      end

      def post(path, data)
        request(
          :post,
          "/api/v1/db/data/v1/#{@db}/#{path}",
          data
        )
      end

      def get(path, data = {})
        puts  path_with_query("/api/v1/db/data/v1/#{@db}/#{path}", data),
        resp = @conn.send_request(
          "GET",
          path_with_query("/api/v1/db/data/v1/#{@db}/#{path}", data),
          "",
          headers.slice("xc-auth")
        )
        case resp
        when Net::HTTPSuccess     # Any success class.
          JSON.parse resp.body, symbolize_names: true
        else
          raise JSON.parse(resp.body)["msg"]
        end
      end

      def path_with_query(path, data)
        if data.empty?
          path
        else
          "#{path}?#{URI.encode_www_form(data)}"
        end
      end

      def patch(path, data)
        request(
          :patch,
          "/api/v1/db/data/v1/#{@db}/#{path}",
          data
        )
      end

      def request(verb, path, data)
        resp = @conn.send_request(
          verb.to_s.upcase,
          path,
          data.to_json,
          headers
        )
        case resp
        when Net::HTTPSuccess     # Any success class.
          JSON.parse resp.body, symbolize_names: true
        else
          raise JSON.parse(resp.body)["msg"]
        end
      end

      def headers
        {
          "accept" => "application/json",
          "Content-Type" => "application/json",
          "xc-auth" => @auth
        }
      end
    end
  end
end
