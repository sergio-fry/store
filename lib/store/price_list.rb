require "store/good"

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

        good_match1 = line.match(%r{([[:alnum:]/\s]+)[^[:alnum:]]-+(\d+)})
        good_match2 = line.match(%r{([[:alnum:]/\s]+)\s[^\s]+-+(\d+)})

        good_match = good_match1 || good_match2

        section = section_match[1] if section_match

        next if good_match.nil?

        yield Good.new(
          device: section.strip,
          model: good_match[1].strip,
          cost: good_match[2].strip.to_i
        )
      end
    end
  end
end
