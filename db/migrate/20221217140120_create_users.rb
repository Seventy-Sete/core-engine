class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :id
      t.string :email
      t.string :password
      t.string :nickname

      t.timestamps
    end
  end
end
