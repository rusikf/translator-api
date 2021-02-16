# frozen_string_literal: true

class TermValidator < ApplicationValidator
  attr_accessor :source_term, :target_term, :glossary
  validate :presence_terms
  validate :valid_terms

  def presence_terms
    puts "source_term: #{source_term}"
    return if source_term.present? && target_term.present?

    errors.add(:base, 'Source term and Target term must present')
  end

  def valid_terms
    return unless glossary.terms.find_by(source_term: source_term, target_term: target_term)

    errors.add(:base, 'Term is already exists')
  end
end
