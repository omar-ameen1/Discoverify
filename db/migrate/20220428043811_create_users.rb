class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :username
      t.string :password_hash
      t.string :spotifyuid

      t.timestamps
    end
  end
end
