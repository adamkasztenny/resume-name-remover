# frozen_string_literal: true

module Service
  class NameRemover
    def initialize(document_reader, name_retriever, name_remover)
      @document_reader = document_reader
      @name_retriever = name_retriever
      @name_remover = name_remover
    end

    def remove
      name = @name_retriever.name
      @name_remover.remove(name: name, text_content: text_content)
    end

    private

    def text_content
      text_for_pages = @document_reader.pages.map(&:text)

      text_for_pages.join("\n")
    end
  end
end
