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

        good_match1 = line.match(%r{([[:alnum:]/\s]+)([^[:alpha:]])-+(\d+)})
        good_match2 = line.match(%r{([[:alnum:]/\s]+)\s([^\sa-zA-Z0-9]+)-+(\d+)})

        good_match = good_match1 || good_match2

        section = section_match[1] if section_match

        next if good_match.nil?

        puts good_match[0]

        yield Good.new(
          device: section.strip,
          model: good_match[1].strip,
          color: parsed_color(good_match[2]),
          cost: good_match[3].strip.to_i
        )
      end
    end

    COLOR_EMOJI = {
      9899 => "black",
      9898 => "white",
      128_308 => "red",
      128_994 => "green",
      128_993 => "yellow",
      128_995 => "violet",
      128_309 => "blue",
      127765 => "yellow_moon",
      128158 => "pink", 
      128992 => "orange"
    }

    def parsed_color(text)
      if text.size > 1
        text
      else
        color = COLOR_EMOJI[text[0].ord]

        raise "unknown color #{text[0]} - #{text[0].ord}" if color.nil?

        color
      end
    end
  end
end
