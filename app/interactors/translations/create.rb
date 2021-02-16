# frozen_string_literal: true

module Translations
  class Create < ApplicationInteractor
    delegate :source_language_code, :target_language_code, :source_text, :glossary_id, to: :context

    def call
      validator = TranslationValidator.new(
        source_language_code: source_language_code,
        target_language_code: target_language_code,
        source_text: source_text,
        glossary_id: glossary_id
      )

      context.fail!(errors: validator.errors.full_messages) if validator.invalid?
      context.result = Translation.create(
        source_language_code: source_language_code,
        target_language_code: target_language_code,
        source_text: source_text,
        glossary_id: glossary_id
      )
    end
  end
end
