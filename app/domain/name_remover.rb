# frozen_string_literal: true

module Domain
  class NameRemover
    def remove(name:, text_content:)
      name_fragments = name.split(/(?=[A-Z])/)
      name_fragments.reduce(text_content) do |content, name_fragment|
        remove_name(name_fragment, content)
      end
    end

    private

    def remove_name(name, text_content)
      text_content.gsub(/#{name}/i, '')
    end
  end
end
