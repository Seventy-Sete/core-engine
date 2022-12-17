class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.string :uuid
      t.string :email
      t.string :password
      t.string :nickname

      t.timestamps
    end
  end
end
