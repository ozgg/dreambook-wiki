# frozen_string_literal: true

# Create tables for dream patterns
class CreatePatterns < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_patterns unless Pattern.table_exists?
    create_pattern_links unless PatternLink.table_exists?
  end

  def down
    drop_table :pattern_links if PatternLink.table_exists?
    drop_table :patterns if Pattern.table_exists?
    BiovisionComponent.where(slug: 'dreambook').delete_all
  end

  private

  def create_component
    BiovisionComponent.create(slug: 'dreambook')
  end

  def create_patterns
    create_table :patterns, comment: 'Dream pattern' do |t|
      t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :words_count, default: 0, null: false
      t.timestamps
      t.string :slug, null: false
      t.string :image
      t.string :title, null: false, index: true
      t.string :summary, null: false
      t.text :description
      t.jsonb :data, default: {}, null: false
    end

    add_index :patterns, %i[slug language_id], unique: true
    add_index :patterns, :data, using: :gin
  end

  def create_pattern_links
    create_table :pattern_links do |t|
      t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :other_pattern_id, null: false
    end

    add_foreign_key :pattern_links, :patterns, column: :other_pattern_id, on_update: :cascade, on_delete: :cascade

    add_index :pattern_links, %i[pattern_id other_pattern_id], unique: true
  end
end
