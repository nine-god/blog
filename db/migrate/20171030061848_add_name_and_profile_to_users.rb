class AddNameAndProfileToUsers < ActiveRecord::Migration[5.1]
  def change
  	    add_column :users, :name, :string, null: false,uniqueness: false
  	    add_column :users, :profile, :string, null: false, default: ""
  end
end
