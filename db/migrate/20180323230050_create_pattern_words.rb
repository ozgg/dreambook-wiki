class CreatePatternWords < ActiveRecord::Migration[5.1]
  def up
    unless PatternWord.table_exists?
      create_table :pattern_words do |t|
        t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :word, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      end

      add_index :pattern_words, [:pattern_id, :word_id], unique: true
    end
  end

  def down
    if PatternWord.table_exists?
      drop_table :pattern_words
    end
  end
end
