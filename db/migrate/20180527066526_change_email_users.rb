class ChangeEmailUsers < ActiveRecord::Migration[5.1]
  def up
    change_table :users do |t|
      t.change :email, :string,null: true
    end
  end
 
  def down
    change_table :users do |t|
      t.change :email, :string,null: false, default: ""
    end
  end
end
