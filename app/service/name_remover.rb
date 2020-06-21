# frozen_string_literal: true

module Service
  class NameRemover
    def initialize(document_reader, name_retriever, name_remover)
      @document_reader = document_reader
      @name_retriever = name_retriever
      @name_remover = name_remover
    end

    def remove
      text_content = @document_reader.text
      name = @name_retriever.name
      @name_remover.remove(name: name, text_content: text_content)
    end
  end
end
