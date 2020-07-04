# frozen_string_literal: true

require 'pdf-reader'

module Domain
  class NameRetriever
    def initialize(reader)
      @name_receiver = NameReciever.new(largest_font_size(reader))
      reader.pages.first.walk(@name_receiver)
    end

    def name
      @name_receiver.name.join('')
    end

    private

    def largest_font_size(reader)
      font_size_receiver = FontSizeReceiver.new
      reader.pages.first.walk(font_size_receiver)
      font_size_receiver.largest_font_size
    end
  end

  class FontSizeReceiver < PDF::Reader::PageTextReceiver
    def initialize
      @largest_font_size = 0
    end

    attr_reader :largest_font_size

    def set_text_font_and_size(label, size)
      @largest_font_size = size if largest_font_size?(size)
      @state.set_text_font_and_size(label, size)
    end

    private

    def largest_font_size?(size)
      size > @largest_font_size
    end
  end

  # Mostly copied from PDF::Reader::PageTextReceiver, the internal_show_text method was modified
  class NameReciever < PDF::Reader::PageTextReceiver
    def initialize(largest_font_size)
      @largest_font_size = largest_font_size
      @name = []
    end

    attr_reader :name

    def show_text(string)
      internal_show_text(string)
    end

    def show_text_with_positioning(params)
      params.each do |arg|
        if arg.is_a?(String)
          internal_show_text(arg)
        else
          @state.process_glyph_displacement(0, arg, false)
        end
      end
    end

    private

    def internal_show_text(string)
      raise PDF::Reader::MalformedPDFError, 'current font is invalid' if @state.current_font.nil?

      glyphs = @state.current_font.unpack(string)
      process_glyphs(glyphs)
    end

    def process_glyphs(glyphs)
      glyphs.each_with_index do |glyph_code, _index|
        new_x, new_y = @state.trm_transform(0, 0)
        utf8_chars = @state.current_font.to_utf8(glyph_code)

        glyph_width = @state.current_font.glyph_width(glyph_code) / 1000.0
        scaled_glyph_width = glyph_width * @state.font_size

        accumulate_name(new_x, new_y, scaled_glyph_width, utf8_chars)
      end
    end

    def accumulate_name(new_x, new_y, scaled_glyph_width, utf8_chars)
      return unless @state.font_size >= @largest_font_size

      @name << PDF::Reader::TextRun.new(new_x, new_y, scaled_glyph_width, @state.font_size, utf8_chars)
    end
  end
end
