class AddProviderAndUidToUsers < ActiveRecord::Migration[5.1]
  def change
		remove_column :users, :profile, :string, null: false, default: ""
		add_column :users, :profile, :text

  	    add_column :users, :provider, :string
  	    add_column :users, :uid, :string

		add_reference :users, :role, foreign_key: true
  	    
  end
end
