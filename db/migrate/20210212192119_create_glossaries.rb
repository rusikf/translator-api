# frozen_string_literal: true

class CreateGlossaries < ActiveRecord::Migration[6.1]
  def change
    create_table :glossaries do |t|
      t.string :source_language_code
      t.string :target_language_code

      t.index %i[source_language_code target_language_code], unique: true, name: 'unique_code_index'
      t.timestamps
    end
  end
end
