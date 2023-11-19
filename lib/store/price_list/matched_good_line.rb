module Store
  class PriceList
    class MatchedGoodLine
      def initialize(line)
        @line = line
      end

      def matched? = !!match

      def model = clean(match[:model])
      def cost = clean(match[:cost])
      def color = match1 ? parsed_color(match1[:color]) : nil

      def match = match1 || match2
      def match1 = @match1 ||= @line.match(regexp1)
      def match2 = @match2 ||= @line.match(regexp2)

      def regexp1 = /(?<model>.+)(?<color>[#{known_colors.join}]).*-+(?<cost>\d+)/u
      def regexp2 = /(?<model>.+)-+(?<cost>\d+)/u


      def clean(text) = text.gsub(/[^[:alnum:]\s()\-\/]/, "").strip

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
        127_800 => "pink",
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

      def known_colors = COLOR_EMOJI.keys.map { |ch| ch.chr(Encoding::UTF_8) }

      def utf_escaped(chars) = chars.map { |ch| "\\u{#{ch.ord}}" }.join
    end
  end
end
