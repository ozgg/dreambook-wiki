# frozen_string_literal: true

# Create table for pending patterns
class CreatePendingPatterns < ActiveRecord::Migration[5.2]
  def up
    create_pending_patterns unless PendingPattern.table_exists?
  end

  def down
    drop_table :pending_patterns if PendingPattern.table_exists?
  end

  private

  def create_pending_patterns
    create_table :pending_patterns, comment: 'Pending pattern for interpretation' do |t|
      t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :pattern, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.boolean :processed, default: false, null: false
      t.string :name, null: false, index: true
      t.timestamps
      t.jsonb :data, default: {}, null: false
    end

    add_index :pending_patterns, :data, using: :gin
  end
end
