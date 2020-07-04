# frozen_string_literal: true

require_relative '../../../app/domain/name_retriever'

describe 'Name Retrieval' do
  context 'when the document is empty' do
    subject do
      reader = PDF::Reader.new('spec/Empty.pdf')
      Domain::NameRetriever.new(reader)
    end

    it "cannot retrieve a candidate's name" do
      expect(subject.name).to be_empty
    end
  end

  context "when the candidate's name is mentioned once in the document" do
    subject do
      reader = PDF::Reader.new('spec/ResumeWithOneMention.pdf')
      Domain::NameRetriever.new(reader)
    end

    it "should retrieve the candidate's name" do
      expect(subject.name).to eq('Candidate Name')
    end
  end

  context "when the candidate's name is mentioned multiple times in the document" do
    subject do
      reader = PDF::Reader.new('spec/ResumeWithMultipleMentions.pdf')
      Domain::NameRetriever.new(reader)
    end

    it "should retrieve the candidate's name" do
      expect(subject.name).to eq('Candidate Name')
    end
  end
end
