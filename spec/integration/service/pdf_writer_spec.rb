# frozen_string_literal: true

require 'pdf-reader'
require_relative '../../../app/service/pdf_writer'

describe 'PDF Writer' do
  subject { Service::PDFWriter.new }

  it 'should write empty text content to a temporary file' do
    empty_text_content = ''

    file = subject.write(empty_text_content)

    expect(file).to be_a(Tempfile)
    expect(pdf_content(file)).to eq(empty_text_content)
    file.unlink
  end

  it 'should write non-empty text content to a temporary file' do
    text_content = 'Some text content'

    file = subject.write(text_content)

    expect(file).to be_a(Tempfile)
    expect(pdf_content(file)).to eq(text_content)
    file.unlink
  end

  it 'should write non-empty text content multiple lines long to a temporary file' do
    text_content = "Some\n text\n\n\n content\n with\n newlines!\n\n\n\n"
    expected_text_content = "Some\ntext\n\n\ncontent\nwith\n\nnewlines!"

    file = subject.write(text_content)

    expect(file).to be_a(Tempfile)
    expect(pdf_content(file)).to eq(expected_text_content)
    file.unlink
  end

  private

  def pdf_content(file)
    reader = PDF::Reader.new(file)
    text_content = reader.pages.map(&:text)
    text_content.join("\n")
  end
end
