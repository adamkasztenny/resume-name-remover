# frozen_string_literal: true

module Domain
  class NameRemover
    def remove(name:, text_content:)
      name_fragments = name.split(/(?=[A-Z])/).map(&:strip)
      replacement_regex = /#{name_fragments.join("|")}/i
      text_content.gsub(replacement_regex, '')
    end
  end
end
