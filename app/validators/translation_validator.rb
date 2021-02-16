# frozen_string_literal: true

class TranslationValidator < ApplicationValidator
  attr_accessor :source_language_code, :target_language_code, :source_text, :glossary_id
  validate :valid_required_fields
  validate :valid_glossary
  validate :source_text_length

  def valid_required_fields
    return if [source_language_code, target_language_code, source_text].all?(&:present?)

    errors.add(:base, 'Source & Target code & source code must present')
  end

  def valid_glossary
    return if glossary_id.blank?
    return if Glossary.find_by(
      id: glossary_id,
      source_language_code: source_language_code,
      target_language_code: target_language_code
    )

    errors.add(:base, 'Glossary not found')
  end

  def source_text_length
    return if source_text && source_text.length <= 5000

    errors.add(:base, 'Source text max length is too high')
  end
end
