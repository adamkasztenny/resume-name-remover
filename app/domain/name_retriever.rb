# frozen_string_literal: true

require 'pdf-reader'

module Domain
  class NameRetriever
    def initialize(reader)
      font_receiver = initialize_font_receiver(reader)
      largest_font_size = font_receiver.largest_font_size
      largest_font_label = font_receiver.largest_font_label

      @name_receiver = NameReciever.new(largest_font_size, largest_font_label)
      reader.pages.first.walk(@name_receiver)
    end

    def name
      @name_receiver.name.join('')
    end

    private

    def initialize_font_receiver(reader)
      font_receiver = FontReceiver.new
      reader.pages.first.walk(font_receiver)
      font_receiver
    end
  end

  class FontReceiver < PDF::Reader::PageTextReceiver
    def initialize
      @largest_font_size = 0
      @largest_font_label = nil
    end

    attr_reader :largest_font_size
    attr_reader :largest_font_label

    def set_text_font_and_size(label, size)
      if is_largest_font?(size)
        @largest_font_size = size
        @largest_font_label = label
      elsif is_label_reused_for_smaller_font?(label, size)
        @largest_font_label = nil
      end

      @state.set_text_font_and_size(label, size)
    end

    private 

    def is_largest_font?(size)
      size > @largest_font_size
    end

    def is_label_reused_for_smaller_font?(label, size)
      @largest_font_label == label && size < @largest_font_size
    end
  end

  # Mostly copied from PDF::Reader::PageTextReceiver, the internal_show_text method was modified
  class NameReciever < PDF::Reader::PageTextReceiver
    def initialize(largest_font_size, largest_font_label)
      @largest_font_size = largest_font_size
      @largest_font_label = largest_font_label
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
      has_largest_font = @state.font_size >= @largest_font_size
      has_largest_font_label = @state.current_font == @state.find_font(@largest_font_label)
      return unless has_largest_font || has_largest_font_label

      @name << PDF::Reader::TextRun.new(new_x, new_y, scaled_glyph_width, @state.font_size, utf8_chars)
    end
  end
end
