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

        good_match1 = line.match(%r{([[:alnum:]/\s]+)([^[:alnum:]])-+(\d+)})
        good_match2 = line.match(%r{([[:alnum:]/\s]+)\s([^\s]+)-+(\d+)})

        good_match = good_match1 || good_match2

        section = section_match[1] if section_match

        next if good_match.nil?

        yield Good.new(
          device: section.strip,
          model: good_match[1].strip,
          color: parsed_color(good_match[2]),
          cost: good_match[3].strip.to_i
        )
      end
    end

    def parsed_color(text)
      if text.size > 1
        text
      else
        case text[0].ord
        when 9898
          'white'
        else
          raise "unknown color #{text[0].ord}"
        end
      end
    end
  end
end
