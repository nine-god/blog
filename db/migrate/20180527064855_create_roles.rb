class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :describe
      t.boolean :admin,  null: false, default: false
      t.boolean :publish_articles,  null: false, default: false
      t.boolean :publish_comments,  null: false, default: false
      

      t.timestamps
    end
  end
end
