class AddSecretToStripeAccounts < ActiveRecord::Migration
  def change
    add_column :stripe_accounts, :secret_key, :string
  end
end
