# frozen_string_literal: true

require 'sinatra'
require 'pdf-reader'
require_relative '../service/name_remover.rb'
require_relative '../domain/name_remover.rb'
require_relative '../domain/name_retriever.rb'

post '/remove' do
  content_type 'application/json'

  error 400 if request_invalid?(params)

  temporary_file = params[:data][:tempfile]
  error 400 if upload_invalid?(params)

  begin
    service = create_service(temporary_file)
    result = service.remove
  ensure
    temporary_file.close
    temporary_file.unlink
  end

  JSON.generate({ 'text_content' => result })
end

private

def request_invalid?(params)
  params[:data].nil? || params[:data][:tempfile].nil?
end

def upload_invalid?(params)
  params[:data][:type] != 'application/pdf'
end

def create_service(temporary_file)
  reader = PDF::Reader.new(temporary_file)
  retreiver = Domain::NameRetriever.new(reader)
  remover = Domain::NameRemover.new
  Service::NameRemover.new(reader, retreiver, remover)
end
