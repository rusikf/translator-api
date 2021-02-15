# frozen_string_literal: true

class GlossaryValidator < ApplicationValidator
  attr_accessor :source_language_code, :target_language_code
  validate :valid_codes
  validate :unique_lang

  def valid_codes
    return if valid_code?(source_language_code) && valid_code?(target_language_code)

    errors.add(:base, 'Source or Target code must be valid')
  end

  def unique_lang
    if Glossary.find_by(source_language_code: source_language_code, target_language_code: target_language_code).nil?
      return
    end

    errors.add(:base, 'Glossary is not unique')
  end

  private

  def valid_code?(code)
    LANGUAGE_CODES_BUILDER.valid_code?(code)
  end
end
