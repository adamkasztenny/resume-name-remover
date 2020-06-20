# frozen_string_literal: true

module Domain
  class NameRemover
    def remove(name, text_content)
      without_name = remove_name(name, text_content)
      remove_name_with_no_spaces(name, without_name)
    end

    private

    def remove_name(name, text_content)
      text_content.gsub(/#{name}/i, '')
    end

    def remove_name_with_no_spaces(name_without_spaces, text_content)
      name_fragments = name_without_spaces.split(/(?=[A-Z])/)
      name_fragments.reduce(text_content) do |content, name_fragment|
        remove_name(name_fragment, content)
      end
    end
  end
end
