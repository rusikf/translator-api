# frozen_string_literal: true

class TranslationRepresenter < ApplicationRepresenter
  property :id
  property :source_language_code
  property :target_language_code
  property :source_text
end

