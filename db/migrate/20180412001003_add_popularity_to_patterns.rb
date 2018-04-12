class AddPopularityToPatterns < ActiveRecord::Migration[5.1]
  def change
    add_column :patterns, :popularity, :integer, default: 0, null: false
  end
end
