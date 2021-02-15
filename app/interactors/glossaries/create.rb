# frozen_string_literal: true

module Glossaries
  class Create < ApplicationInteractor
    delegate :source_language_code, :target_language_code, to: :context

    def call
      validator = GlossaryValidator.new(source_language_code: source_language_code, target_language_code: target_language_code)

      context.fail!(errors: validator.errors.full_messages) if validator.invalid?
      context.result = Glossary.create(
        source_language_code: source_language_code,
        target_language_code: target_language_code
      )
    end
  end
end
