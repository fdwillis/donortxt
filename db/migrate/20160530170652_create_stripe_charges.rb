class CreateStripeCharges < ActiveRecord::Migration
  def change
    create_table :stripe_charges do |t|
      t.float :state
      t.float :hack

      t.timestamps null: false
    end
  end
end
