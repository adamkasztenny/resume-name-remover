# frozen_string_literal: true

module Service
  class NameRemover
    def initialize(name_retriever, name_remover)
      @name_retriever = name_retriever
      @name_remover = name_remover
    end

    def remove(document)
      name = @name_retriever.name
      # TODO: actually read the document into text here
      text_content = document
      @name_remover.remove(name: name, text_content: text_content)
    end
  end
end
