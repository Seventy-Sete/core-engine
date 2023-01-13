class CreateBankTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_transactions do |t|
      t.string :user_bank_id, null: false
      t.string :title
      t.float :amount
      t.datetime :due_date
      t.string :tags, array: true, default: []
      t.integer :purpose, default: 7
      t.string :transaction_id

      t.timestamps
    end

    add_index :bank_transactions, :user_bank_id
  end
end
