class CreateWords < ActiveRecord::Migration[5.1]
  def up
    unless Word.table_exists?
      create_table :words do |t|
        t.timestamps
        t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :patterns_count, limit: 2, default: 0, null: false
        t.string :body, null: false
      end

      add_index :words, [:body, :language_id], unique: true
    end
  end

  def down
    if Word.table_exists?
      drop_table :words
    end
  end
end
