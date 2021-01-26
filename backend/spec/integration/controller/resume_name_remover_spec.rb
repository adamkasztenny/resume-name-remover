# frozen_string_literal: true

require_relative '../integration_spec_helper'
require_relative '../../../app/controller/resume_name_remover'
require_relative '../../pdf_content'
require 'json'

describe 'Resume Name Remover Controller' do
  it 'should return a PDF' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/Empty.pdf', 'application/pdf')

    expect(last_response.status).to eq(200)
    expect(content_type).to eq('application/pdf')
  end

  it 'should return a PDF of a resume without any mentions of the candidate name' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/ResumeWithMultipleMentions.pdf', 'application/pdf')

    pdf = last_response.body
    temporary_file = Tempfile.new
    temporary_file.write(pdf)
    text_content = pdf_content(temporary_file)

    expect(content_type).to eq('application/pdf')
    expect(last_response.status).to eq(200)

    expect(text_content).not_to be_empty
    expect(text_content).not_to match(/Candidate/i)
    expect(text_content).not_to match(/Name/i)

    temporary_file.unlink
  end

  it 'accepts files under 200 KB' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/Large.pdf', 'application/pdf')

    expect(last_response.status).to eq(200)
    expect(content_type).to eq('application/pdf')
  end

  it 'should return a 400 if there is no uploaded file' do
    post '/remove'

    expect(last_response.status).to eq(400)
    expect(content_type).not_to eq('application/pdf')
  end

  it 'should return a 400 if the uploaded file does not have the application/pdf content type' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/ResumeWithOneMention.odt', 'application/octet-stream')

    expect(last_response.status).to eq(400)
    expect(content_type).not_to eq('application/pdf')
  end

  it 'should return a 400 if the uploaded file does not have a PDF extension' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/PDFWithoutExtension', 'application/pdf')

    expect(last_response.status).to eq(400)
    expect(content_type).not_to eq('application/pdf')
  end

  it 'should return a 400 if the uploaded file is not actually a PDF' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/NotAPDF.pdf', 'application/pdf')

    expect(last_response.status).to eq(400)
    expect(content_type).not_to eq('application/pdf')
  end

  it 'should return a 413 if the uploaded file is over 200 KB' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/TooLarge.pdf', 'application/pdf')

    expect(last_response.status).to eq(413)
    expect(content_type).not_to eq('application/pdf')
  end

  private

  def content_type
    last_response.headers['Content-Type']
  end
end
