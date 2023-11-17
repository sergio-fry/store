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
        section = section_match[1] if section_match

        good_match1 = line.match(%r{(.+)([^[:alnum:]\s\)])-+(\d+)})
        good_match2 = line.match(%r{(.+)-+(\d+)})

        good_match = if good_match1
                       {
                         model: good_match1[1],
                         color: good_match1[2],
                         cost: good_match1[3]
                       }
                     elsif good_match2
                       {
                         model: good_match2[1],
                         cost: good_match2[2]
                       }
                     end

        next if good_match.nil?

        puts line
        debugger
        yield Good.new(
          device: remove_garbage((section || "")),
          model: remove_garbage(good_match[:model]),
          color: parsed_color(good_match[:color]),
          cost: good_match[:cost].strip.to_i
        )
      end
    end

    COLOR_EMOJI = {
      127_765 => "yellow_moon",
      128_158 => "pink",
      128_280 => "grey",
      128_308 => "red",
      128_309 => "blue",
      128_992 => "orange",
      128_993 => "yellow",
      128_994 => "green",
      128_995 => "violet",
      127800 => "pink",
      9898 => "white",
      9899 => "black"
    }

    def parsed_color(text)
      return if text.nil?

      if text.size > 1
        text
      else
        color = COLOR_EMOJI[text[0].ord]

        raise "unknown color #{text[0]} - #{text[0].ord}" if color.nil?

        color
      end
    end

    def remove_garbage(text)
      text.gsub(/[^[:alnum:]\s\(\)]/, "").strip
    end
  end
end
