class CreateBankTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_transactions do |t|
      t.string :user_bank_id, null: false
      t.string :title
      t.float :amount
      t.string :due_date
      t.jsonb :tags
      t.string :transaction_id

      t.timestamps
    end

    add_index :bank_transactions, :user_bank_id
  end
end
