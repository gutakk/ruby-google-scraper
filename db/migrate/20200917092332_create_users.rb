class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :username, unique: true, name: 'unique_users_on_username'
  end
end
