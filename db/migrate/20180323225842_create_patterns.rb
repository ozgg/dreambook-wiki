class CreatePatterns < ActiveRecord::Migration[5.1]
  def up
    unless Pattern.table_exists?
      create_table :patterns do |t|
        t.timestamps
        t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.boolean :approved, default: false, null: false
        t.boolean :locked, default: false, null: false
        t.integer :words_count, limit: 2, default: 0, null: false
        t.string :image
        t.string :title, null: false
        t.string :slug, null: false
        t.string :essence
        t.text :interpretation, null: false
      end

      add_index :patterns, [:slug, :language_id], unique: :true
      add_index :patterns, [:approved, :language_id]

      create_privileges
    end
  end

  def down
    if Pattern.table_exists?
      drop_table :patterns
    end
  end

  def create_privileges
    chief = Privilege.find_by(slug: 'chief_interpreter')
    if chief.nil?
      chief = Privilege.create(slug: 'chief_interpreter', name: 'Главный интерпретатор')
    end

    interpreter = Privilege.find_by(slug: 'interpreter')
    if interpreter.nil?
      interpreter = Privilege.create(slug: 'interpreter', name: 'Интерпретатор', parent: chief)
    end

    suggester = Privilege.find_by(slug: 'suggester')
    if suggester.nil?
      Privilege.create(slug: 'suggester', name: 'Предлагатель', parent: interpreter)
    end
  end
end
