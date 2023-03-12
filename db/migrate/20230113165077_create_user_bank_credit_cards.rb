class CreateUserBankCreditCards < ActiveRecord::Migration[7.0]
  def change
    create_table :user_bank_credit_cards do |t|
      t.string :user_bank_credit_id
      t.integer :number
      t.string :name

      t.timestamps
    end
  end
end
