# frozen_string_literal: true

class Translation < ApplicationRecord
  belongs_to :glossary, optional: true
end

