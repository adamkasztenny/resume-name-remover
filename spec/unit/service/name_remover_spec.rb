# frozen_string_literal: true

require_relative '../../../app/service/name_remover'

describe 'Name Remover Service' do
  let(:fake_document_pages) { [double('page1'), double('page2')] }
  let(:fake_name) { 'Candidate Name' }
  let(:text_content) { 'Some Annonymized Resume' }

  it "removes the candidate's name from the given document" do
    document_reader = double('document_reader')
    name_retriever = double('name_retriever')
    name_remover = double('name_remover')

    fake_document_pages.each do |page| 
      expect(page).to receive(:text).and_return("some page text")
    end
    expect(document_reader).to receive(:pages).and_return(fake_document_pages)
    expect(name_retriever).to receive(:name).and_return(fake_name)
    expect(name_remover).to receive(:remove).and_return(text_content)

    service = Service::NameRemover.new(document_reader, name_retriever, name_remover)

    result = service.remove
    expect(result).to equal(text_content)
  end
end
