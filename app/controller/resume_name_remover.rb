# frozen_string_literal: true

require 'sinatra'
require 'pdf-reader'
require_relative '../service/name_remover.rb'
require_relative '../domain/name_remover.rb'
require_relative '../domain/name_retriever.rb'

post '/remove' do
  content_type 'application/json'

  temporary_file = params[:data][:tempfile]
  begin
    reader = PDF::Reader.new(temporary_file)
    retreiver = Domain::NameRetriever.new(reader)
    remover = Domain::NameRemover.new
    service = Service::NameRemover.new(reader, retreiver, remover)
    result = service.remove
  ensure
    temporary_file.close
    temporary_file.unlink
  end

  JSON.generate({ 'text_content' => result })
end
