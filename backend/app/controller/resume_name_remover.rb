# frozen_string_literal: true

require 'sinatra'
require 'pdf-reader'
require_relative '../service/name_remover.rb'
require_relative '../service/pdf_writer.rb'
require_relative '../domain/name_remover.rb'
require_relative '../domain/name_retriever.rb'

post '/remove' do
  error 400 if request_invalid?(params)

  temporary_input_file = params[:data][:tempfile]
  error 400 if upload_invalid?(params)

  error 413 if upload_too_large?(params)

  begin
    name_remover_service = create_name_remover_service(temporary_input_file)
    text_content = name_remover_service.remove
    temporary_output_file = Service::PDFWriter.write(text_content)
  rescue PDF::Reader::MalformedPDFError
    error 400
  ensure
    temporary_input_file.close
    temporary_input_file.unlink
  end

  content_type 'application/pdf'
  send_file temporary_output_file, type: 'application/pdf'
  temporary_file.unlink
end

private

MAXIMUM_FILE_SIZE_IN_BYTES = 200 * 1024

def request_invalid?(params)
  params[:data].nil? || params[:data][:tempfile].nil?
end

def upload_invalid?(params)
  params[:data][:type] != 'application/pdf' || !params[:data][:tempfile].path.end_with?('.pdf')
end

def upload_too_large?(params)
    params[:data][:tempfile].size > MAXIMUM_FILE_SIZE_IN_BYTES
end

def create_name_remover_service(temporary_input_file)
  reader = PDF::Reader.new(temporary_input_file)
  retreiver = Domain::NameRetriever.new(reader)
  remover = Domain::NameRemover.new
  Service::NameRemover.new(reader, retreiver, remover)
end
