# frozen_string_literal: true

class TranslationDetailsRepresenter < ApplicationRepresenter
  property :source_text
  property :glossary_terms
  property :highlighted_source_text, exec_context: :decorator

  def highlighted_source_text
    return represented.source_text if represented.glossary_terms.blank?

    represented.source_text.split(' ').map do |word|
      represented.glossary_terms.include?(word) ? "<HIGHLIGHT>#{word}</HIGHLIGHT>" : word
    end.join(' ')
  end
end
