# frozen_string_literal: true

# Create tables for dreams
class CreateDreams < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_dreams unless Dream.table_exists?
    create_word_links unless DreamWord.table_exists?
    create_pattern_links unless DreamPattern.table_exists?
    add_pending_pattern_weight unless column_exists? :pending_patterns, :weight
    add_dream_counters
  end

  def down
    drop_table :dream_patterns if DreamPattern.table_exists?
    drop_table :dream_words if DreamWord.table_exists?
    drop_table :dreams if Dream.table_exists?
  end

  private

  def create_component
    BiovisionComponent.create(slug: 'dreams')
    Privilege.create(slug: 'dreams_manager', name: 'Управляющий снами')
  end

  def create_dreams
    create_table :dreams, comment: 'Dreams' do |t|
      t.uuid :uuid, null: false, index: true
      t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.boolean :personal, default: false, null: false
      t.integer :comments_count, default: 0, null: false
      t.timestamps
      t.string :title
      t.text :body, null: false
      t.jsonb :data, default: {}, null: false
    end

    add_index :dreams, :data, using: :gin
  end

  def create_word_links
    create_table :dream_words, comment: 'Word occurring in dream' do |t|
      t.references :dream, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :word, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :weight, default: 1, null: false
    end
  end

  def create_pattern_links
    create_table :dream_patterns, comment: 'Pattern occurring in dream' do |t|
      t.references :dream, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :pattern, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :weight, default: 1, null: false
    end
  end

  def add_pending_pattern_weight
    add_column :pending_patterns, :weight, :integer, default: 0, null: false
  end

  def add_dream_counters
    unless column_exists? :patterns, :dreams_count
      add_column :patterns, :dreams_count, :integer, default: 0, null: false
    end

    unless column_exists? :words, :dreams_count
      add_column :words, :dreams_count, :integer, default: 0, null: false
    end
  end
end
