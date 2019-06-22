# frozen_string_literal: true

# Add data column to pending patterns
class AddDataToPendingPatterns < ActiveRecord::Migration[5.2]
  def up
    return if column_exists? :pending_patterns, :data

    add_column :pending_patterns, :data, :jsonb, default: {}, null: false
    add_index :pending_patterns, :data, using: :gin
  end

  def down
    # No rollback needed
  end
end
