# frozen_string_literal: true

class Translation < ApplicationRecord
  belongs_to :glossary, optional: true

  def glossary_terms
    return [] if glossary.blank?

    terms = source_text.split(' ')

    terms.select do |term|
      glossary.terms.find_by(source_term: term)
    end
  end
end
