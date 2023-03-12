class CreateUserBankCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :user_bank_credits do |t|
      t.float :total
      t.string :user_bank_id
      t.float :current
      t.float :used

      t.timestamps
    end
  end
end
