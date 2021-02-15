# frozen_string_literal: true

class GlossaryRepresenter < ApplicationRepresenter
  property :id
  property :source_language_code
  property :target_language_code
end
