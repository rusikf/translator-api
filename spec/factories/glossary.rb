# frozen_string_literal: true

FactoryBot.define do
  factory :glossary do
    trait :en_nl do
      source_language_code { 'en' }
      target_language_code { 'nl' }
    end
  end
end
