# frozen_string_literal: true

require_relative '../../../app/domain/name_remover'

describe 'Name Removal' do
  subject do
    Domain::NameRemover.new
  end

  context 'when the text content is empty' do
    candidate_name = 'Candidate Name'
    text_content = ''

    it 'does not include the candidate name' do
      result = subject.remove(name: candidate_name, text_content: text_content)

      expect(result).to be_empty
      expect(result).not_to include(candidate_name)
    end
  end

  context 'when the text content is not empty' do
    context "when the candidate's name is mentioned once" do
      candidate_name = 'Candidate Name'
      text_content = %{
Candidate Name                      Education

100 DerpAvenue                     PhD in Derping
                                   University of Blorp, May 2015
Address Line 2                     Cumulative GPA: 3.89
(555) 555 5555
                                   BS in Blorpology
derp@example.com
                                   Blorf College, May 2001
example.com                        Cumulative GPA: 2.26


                                    Experience

                                   Chief Derping Officer                        July 2011 – Mar 2012
                                   Some Company

                                       •   Derped pretty hard

                                       •   Coordinated derping efforts

                                   Senior Derper                                Apr 2001 – Jan 2011
                                   Some Other Company

                                       •   Guided junior derpers

                                       •   Created derp infrastructure


                                    Skills

                                       •   Derping                      •   Golang

                                       •   LibreOffice                  •   PDFs
      }

      it 'does not include any part of the candidate name' do
        result = subject.remove(name: candidate_name, text_content: text_content)

        expect(result).not_to be_empty
        expect(result).not_to include('Candidate')
        expect(result).not_to include('Name')
      end
    end

    context "when the candidate's name is mentioned multiple times" do
      candidate_name = 'Candidate Name'
      text_content = %{
My name is CaNdiDate NaMe!


                                    Education
Candidate Name
                                   PhD in Derping
100 DerpAvenue                     University of Blorp, May 2015
Address Line 2
                                   Cumulative GPA: 3.89
(555) 555 5555
                                   BS in Blorpology
candidate.name@example.com         Blorf College, May 2001
candidate.name.example.com         Cumulative GPA: 2.26


                                    Experience

                                   Chief Derping Officer                        July 2011 – Mar 2012
                                   Some Company

                                       •   Derped pretty hard

                                       •   Coordinated derping efforts

                                   Senior Derper                                Apr 2001 – Jan 2011
                                   Some Other Company

                                       •   Guided junior derpers

                                       •   Created derp infrastructure


                                    Skills

                                       •   Derping

                                       •   LibreOffice               (Continued on the next page)

Candidate Name is my name
      }

      it 'does not include any part of the candidate name' do
        result = subject.remove(name: candidate_name, text_content: text_content)

        expect(result).not_to be_empty
        expect(result).not_to match(/Candidate/i)
        expect(result).not_to match(/Name/i)
      end
    end

    context "when the candidate's name is more than two words" do
      candidate_name = 'The Candidate Name Jr.'
      text_content = %{
My name is tHe CaNdiDate NaMe JR.!


                                    Education
The Candidate Name Jr.
                                   PhD in Derping
100 DerpAvenue                     University of Blorp, May 2015
Address Line 2
                                   Cumulative GPA: 3.89
(555) 555 5555
                                   BS in Blorpology
candidate.the.name.jr@example.com         Blorf College, May 2001
candidate.the.name.jr@example.com         Cumulative GPA: 2.26


                                    Experience

                                   Chief Derping Officer                        July 2011 – Mar 2012
                                   Some Company

                                       •   Derped pretty hard

                                       •   Coordinated derping efforts

                                   Senior Derper                                Apr 2001 – Jan 2011
                                   Some Other Company

                                       •   Guided junior derpers

                                       •   Created derp infrastructure


                                    Skills

                                       •   Derping

                                       •   LibreOffice               (Continued on the next page)
}
      it 'does not include any part of the candidate name' do
        result = subject.remove(name: candidate_name, text_content: text_content)

        expect(result).not_to be_empty
        expect(result).not_to match(/The/i)
        expect(result).not_to match(/Candidate/i)
        expect(result).not_to match(/Name/i)
        expect(result).not_to match(/Jr/i)
      end
    end

    context "when the candidate's name has no spaces" do
      candidate_name_without_spaces = 'CandidateName'
      text_content = %(
        CandidateName

        I'm Candidate Name!
        Lorem ipsum
      )

      it 'does not include any part of the candidate name' do
        result = subject.remove(name: candidate_name_without_spaces, text_content: text_content)

        expect(result).not_to be_empty
        expect(result).not_to include('Candidate')
        expect(result).not_to include('Name')
      end
    end

    context "when the candidate's name is only one word" do
      single_word_candidate_name = 'Candidate'
      text_content = %(
        Candidate

        I'm Candidate!
        Lorem ipsum
      )

      it 'does not include the candidate name' do
        result = subject.remove(name: single_word_candidate_name, text_content: text_content)

        expect(result).not_to be_empty
        expect(result).not_to include('Candidate')
      end
    end

    context "when the candidate's name is empty" do
      candidate_name = ''
      text_content = %(
        CandidateName

        I'm Candidate Name!
      )

      it 'returns the text content unmodified' do
        result = subject.remove(name: candidate_name, text_content: text_content)

        expect(result).not_to be_empty
        expect(result).to eq(text_content)
      end
    end
  end
end
