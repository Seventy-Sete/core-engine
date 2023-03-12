# frozen_string_literal: true

module Nubank
  class FetchAccountDetails < ApplicationService
    include NubankSdk

    attr_reader :user_bank_id

    def initialize(user_bank_id)
      @user_bank_id = user_bank_id
    end

    def call
      user_nubank.auth.authenticate_with_certificate(user_bank.access_key)
      unprocessed = []
      new_transactions = []
      sorted_feed = user_nubank.account.feed.sort_by { |feed| feed[:postDate] }
      sorted_feed.each do |feed|
        next if BankTransaction.exists?(transaction_id: feed[:id])

        if feed[:__typename] == 'GenericFeedEvent'
          if feed[:title] == 'Transferência enviada'
            detail = feed[:detail].split("\n") # "NOME PESSOA\nR$ 1.234,56" => ["NOME PESSOA", "R$ 1.234,56"]
            name = detail.first
            amount = detail.last || 'R$ 0'
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: "#{feed[:title]} para #{name}",
              amount: amount.gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :transfer
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :outgoing)
            next
          end

          if feed[:title] == 'Transferência recebida'
            detail = feed[:detail].split("\n") # "NOME PESSOA\nR$ 1.234,56" => ["NOME PESSOA", "R$ 1.234,56"]
            name = detail.first
            amount = detail.last || 'R$ 0'
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: "#{feed[:title]} de #{name}",
              amount: amount.gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :deposit
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :incoming)
            next
          end

          if feed[:title] == 'Pagamento da fatura'
            amount = feed[:detail].gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: feed[:title],
              amount:,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :payment
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :outgoing)
            next
          end

          if feed[:title] == 'Depósito recebido'
            amount = feed[:detail].gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: feed[:title],
              amount: amount,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :deposit
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :incoming)
            next
          end

          if feed[:title] == 'Venda de Criptomoeda'
            amount = feed[:detail].gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: feed[:title],
              amount: amount,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :deposit
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :incoming)
            next
          end

          if feed[:title] == 'Reembolso enviado'
            detail = feed[:detail].split("\n") # "NOME PESSOA\nR$ 1.234,56" => ["NOME PESSOA", "R$ 1.234,56"]
            name = detail.first
            amount = detail.last || 'R$ 0'
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: "#{feed[:title]} para #{name}",
              amount: amount.gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :transfer
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :outgoing)
            next
          end

          if feed[:title] == 'Compra no débito'
            detail = feed[:detail].split("\n") # "NOME PESSOA\nR$ 1.234,56" => ["NOME PESSOA", "R$ 1.234,56"]
            name = detail.first
            amount = detail.last || 'R$ 0'
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: "#{feed[:title]} em #{name}",
              amount: amount.gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :payment
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :outgoing)
            next
          end
          
          if feed[:title] == 'Parcela paga'
            detail = feed[:detail].split("\n") # "NOME PESSOA\nR$ 1.234,56" => ["NOME PESSOA", "R$ 1.234,56"]
            name = detail.first
            amount = detail.last || 'R$ 0'
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: "#{feed[:title]} de #{name}",
              amount: amount.gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :payment
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :outgoing)
            next
          end

          if feed[:title] == 'Dinheiro resgatado'
            amount = feed[:detail].gsub('R$ ', '').gsub('.', '').gsub(',', '.').to_f
            post_date = feed[:postDate] # => "2023-12-31"

            new_transactions << {
              transaction_id: feed[:id],
              user_bank_id: user_bank.id,
              title: feed[:title],
              amount: amount,
              due_date: DateTime.parse(post_date),
              tags: [],
              purpose: :deposit
            }
            update_user_balance(BankTransaction.create(new_transactions.last), :incoming)
            next
          end
        end

        unprocessed << feed
      end

      puts new_transactions[0]

      { unprocessed: unprocessed, new_transactions: new_transactions, credit_feed: user_nubank.credit.feed, credit_balances: user_nubank.credit.balances }
    end

    private

    def user_nubank
      @user_nubank ||= NubankSdk::User.new cpf: user_bank.bcn
    end

    def user_bank
      @user_bank ||= UserBank.find(user_bank_id)
    end

    def update_user_balance(transaction, type)
      reference = transaction.due_date.strftime('%Y%m').to_i

      transaction_reference = transaction.user_bank.bank_details.find_by(reference: reference)
      total = (transaction.amount * 100).to_i
      if transaction_reference
        if type == :outgoing
          transaction_reference.update(
            balance: ((transaction_reference.balance * 100).to_i - total).to_f / 100,
            outgoing: ((transaction_reference.outgoing * 100).to_i + total).to_f / 100
          )
        else
          transaction_reference.update(
            balance: ((transaction_reference.balance * 100).to_i + total).to_f / 100,
            incoming: ((transaction_reference.incoming * 100).to_i + total).to_f / 100
          )
        end
      else
        last_reference = transaction.user_bank.bank_details.where('reference < ?', reference).order(reference: :desc).limit(1).first
        last_balance = last_reference ? last_reference.balance : 0.to_f

        if type == :outgoing
          puts 'entrou aqui :transfer'
          BankDetail.create(
            reference: reference,
            balance: ((last_balance * 100).to_i - total).to_f / 100,
            outgoing: (total.to_f / 100),
            incoming: 0,
            user_bank_id: transaction.user_bank.id
          )
        else
          puts 'entrou aqui :deposit'
          BankDetail.create(
            reference: reference,
            balance: ((last_balance * 100).to_i + total).to_f / 100,
            incoming: (total.to_f / 100),
            outgoing: 0,
            user_bank_id: transaction.user_bank.id
          )
        end
      end
    end
  end
end
