# frozen_string_literal: true

require_relative '../integration_spec_helper.rb'
require_relative '../../../app/controller/resume_name_remover'
require 'json'

describe 'Resume Name Remover Controller' do
  it 'should return JSON' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/Empty.pdf', 'application/pdf')

    content_type = last_response.headers['Content-Type']
    expect(content_type).to eq('application/json')

    body_as_json = JSON.parse(response_body)
    expect(body_as_json).not_to be_empty
  end

  it 'should return the text content of a resume without any mentions of the candidate name' do
    post '/remove', data: Rack::Test::UploadedFile.new('spec/ResumeWithMultipleMentions.pdf', 'application/pdf')

    body_as_json = JSON.parse(response_body)
    text_content = body_as_json['text_content']

    expect(text_content).not_to be_empty
    expect(text_content).not_to match(/Candidate/i)
    expect(text_content).not_to match(/Name/i)
  end

  it 'should return a 400 if there is no uploaded file' do
    post '/remove'

    expect(last_response.status).to eq(400)
  end

  it 'should return a 400 if the uploaded file is not a PDF' do
    post '/remove', Rack::Test::UploadedFile.new('spec/ResumeWithOneMention.odt', 'application/octet-stream')

    expect(last_response.status).to eq(400)
  end
end
