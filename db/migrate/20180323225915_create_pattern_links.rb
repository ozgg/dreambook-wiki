class CreatePatternLinks < ActiveRecord::Migration[5.1]
  def up
    unless PatternLink.table_exists?
      create_table :pattern_links do |t|
        t.timestamps
        t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :other_pattern_id, null: false
      end

      add_foreign_key :pattern_links, :patterns, column: :other_pattern_id, on_update: :cascade, on_delete: :cascade

      add_index :pattern_links, [:pattern_id, :other_pattern_id], unique: true
    end
  end

  def down
    if PatternLink.table_exists?
      drop_table :pattern_links
    end
  end
end
