class ChangeUsers < ActiveRecord::Migration[5.1]
  def change
  	    remove_column :users, :name, :string, null: false
  	    add_column :users, :username, :string, null: false , default: ""
  	    add_column :users, :name, :string, null: false , default: ""

  	    add_index :users, :username,                unique: true
  end
end
