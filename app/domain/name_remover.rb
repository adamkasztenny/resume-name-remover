# frozen_string_literal: true

module Domain
  class NameRemover
    def remove(name, text_content)
      text_content.gsub(/#{name}/i, '')
    end
  end
end
