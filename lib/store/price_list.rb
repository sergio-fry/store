require "store/good"
require "store/price_list/matched_good_line"

module Store
  class PriceList
    include Enumerable

    def initialize(lines)
      @lines = lines
    end

    def each
      section = nil

      @lines.each do |line|
        next if line.strip.empty?

        section_match = line.match(%r{\s\s\s+[^[:alnum:]]+([[:alnum:]/\s]+)})
        section = section_match[1] if section_match

        good_match = MatchedGoodLine.new(line)

        next if good_match.matched?

        yield Good.new(
          device: remove_garbage((section || "")),
          model: remove_garbage(good_match.model),
          color: good_match.color,
          cost: good_match.cost.strip.to_i
        )
      end
    end

    def remove_garbage(text)
      text.gsub(/[^[:alnum:]\s()]/, "").strip
    end
  end
end
