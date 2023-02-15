# frozen_string_literal: true

class CreateBankDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_details do |t|
      t.integer :reference
      t.float :balance
      t.float :incoming
      t.float :outgoing
      t.string :user_bank_id

      t.timestamps
    end

    add_index :bank_details, :reference
  end
end
