# frozen_string_literal: true

require_relative '../../app/service/name_remover'

describe 'Name Remover Service' do
  fake_name = 'Candidate Name'
  fake_document = 'Some Resume with the Candidate Name'
  text_content = 'Some Annonymized Resume'

  it "removes the candidate's name from the given document" do
    name_retriever = double('name_retriever')
    name_remover = double('name_remover')

    expect(name_retriever).to receive(:name).and_return(fake_name)
    expect(name_remover).to receive(:remove).and_return(text_content)

    service = Service::NameRemover.new(name_retriever, name_remover)

    result = service.remove(fake_document)
    expect(result).to equal(text_content)
  end
end
