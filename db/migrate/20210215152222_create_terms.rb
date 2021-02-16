# frozen_string_literal: true

class CreateTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :terms do |t|
      t.belongs_to :glossary
      t.string :source_term
      t.string :target_term
      t.timestamps
    end

    add_index :terms, %i[source_term target_term], unique: true
  end
end
