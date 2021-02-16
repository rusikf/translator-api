# frozen_string_literal: true

class Glossary < ApplicationRecord
  has_many :terms, dependent: :destroy
end
