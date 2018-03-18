class AddHitsToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :hits, :integer,default: 0, null: false
  end
end
