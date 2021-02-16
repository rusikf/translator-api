# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[6.1]
  def change
    create_table :translations do |t|
      t.text :source_text
      t.string :source_language_code
      t.string :target_language_code
      t.belongs_to :glossary

      t.timestamps
    end
  end
end
