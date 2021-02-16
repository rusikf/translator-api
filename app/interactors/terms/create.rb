# frozen_string_literal: true

module Terms
  class Create < ApplicationInteractor
    delegate :source_term, :target_term, :glossary, to: :context

    def call
      validator = TermValidator.new(
        source_term: source_term,
        target_term: target_term,
        glossary: glossary
      )

      context.fail!(errors: validator.errors.full_messages) if validator.invalid?
      context.result = Term.create(
        source_term: source_term,
        target_term: target_term,
        glossary: glossary
      )
    end
  end
end
