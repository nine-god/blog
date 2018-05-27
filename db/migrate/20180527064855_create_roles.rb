class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :describe
      t.boolean :publish_articles

      t.timestamps
    end
  end
end
