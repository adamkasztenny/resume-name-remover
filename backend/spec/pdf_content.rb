# frozen_string_literal: true

require 'pdf-reader'

def pdf_content(pdf)
  reader = PDF::Reader.new(pdf)
  text_for_pages = reader.pages.map(&:text)
  text_for_pages.join("\n")
end
