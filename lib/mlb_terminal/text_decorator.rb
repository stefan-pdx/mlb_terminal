require 'colorize'

module MLBTerminal
  class TextDecorator
    def initialize(input)
      @input = input
    end

    def beautify_event
      output = []
      r = @input[5].sub("Jr.", "Jr")
      t = r.split(". ")
      t.each do |w|
        w.strip
        if w.downcase.include?("single") || w.downcase.include?("double") ||
            w.downcase.include?("triple")
          output << w.colorize(:green)
        elsif w.downcase.include?("homer") || w.downcase.include?("scores")
          output << w.colorize(:color => :black, :background => :green).bold
        elsif w.downcase.include?("out")
          output << w.colorize(:red)
        elsif w.downcase.include?("walk") || w.downcase.include?("hit by")
          output << w.colorize(:blue)
        elsif w.downcase.include?("error")
          output << w.colorize(:yellow)
        elsif w.downcase.include?("to")
          output << w.colorize(:blue)
        else
          output << w
        end
      end
      out_text = output.join(". ")
      beautified = [@input[0..4], out_text].join("\t")
      puts beautified
    end

    def beautify_game
      t = @input
      if t.downcase.include?("game over") || t.downcase.include?("final")
        output = t.colorize(:light_red)
      elsif t.downcase.include?("in progress")
        output = t.colorize(:green)
      elsif t.downcase.include?("warmup") || t.downcase.include?("pre-game")
        output = t.colorize(:blue)
      else
        output = t
      end
      puts output
    end
  end
end
