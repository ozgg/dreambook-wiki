# frozen_string_literal: true

# Create tables for words and pattern-word links
class CreateWords < ActiveRecord::Migration[5.2]
  def up
    create_words unless Word.table_exists?
    create_pattern_words unless PatternWord.table_exists?
  end

  def down
    drop_table :pattern_words if PatternWord.table_exists?
    drop_table :words if Word.table_exists?
  end

  private

  def create_words
    create_table :words, comment: 'Word' do |t|
      t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :processed, default: false, null: false
      t.integer :weight, default: 0, null: false
      t.integer :patterns_count, default: 0, null: false
      t.timestamps
      t.string :body, null: false
    end

    add_index :words, %i[body language_id], unique: true
  end

  def create_pattern_words
    create_table :pattern_words, comment: 'Word for pattern' do |t|
      t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :word, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end

    add_index :pattern_words, %i[pattern_id word_id], unique: true
  end
end
