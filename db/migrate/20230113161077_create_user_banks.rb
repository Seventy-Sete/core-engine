class CreateUserBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_banks do |t|
      t.string :bank_name
      t.string :user_id
      t.string :bcn
      t.string :access_key

      t.timestamps
    end

    add_index :user_banks, :user_id
  end
end
