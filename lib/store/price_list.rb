require "store/good"
require "store/price_list/matched_good_line"

module Store
  class PriceList
    include Enumerable

    def initialize(lines)
      @lines = lines
    end

    def each
      section = ""
      lines_without_section = 0

      @lines.each do |line|
        good_match = MatchedGoodLine.new(line)

        unless good_match.matched?
          section_match = line.match(%r{\s\s\s+[^[:alnum:]]+([[:alnum:]/\s]+)})

          if section_match
            lines_without_section = 0
            section = clean(section_match[1] || "")
          else
            lines_without_section += 1
          end
        end

        section = "" if lines_without_section > 1

        next unless good_match.matched?

        yield Good.new(
          device: section,
          model: good_match.model,
          color: good_match.color,
          cost: good_match.cost.to_i
        )
      end
    end

    def clean(text) = text.gsub(/[^[:alnum:]\s()]/, "").strip
  end
end
