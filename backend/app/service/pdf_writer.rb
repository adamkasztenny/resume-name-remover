# frozen_string_literal: true

require 'prawn'

module Service
  class PDFWriter
    def write(text_content)
      file = Tempfile.new
      Prawn::Document.generate(file) do
        text text_content
      end

      file
    end
  end
end
