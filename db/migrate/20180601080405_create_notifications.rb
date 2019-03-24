class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.integer :actor_id
      t.string :notify_type, null: false
      t.string :target_type
      t.integer :target_id
      t.string   :second_target_type
      t.integer  :second_target_id
      t.datetime :read_at
      t.timestamps
    end
  end
end
