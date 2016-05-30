require "active_support"

@crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])

namespace :payout do
  include ActionView::Helpers::NumberHelper

  twilio_text = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
  
  task all: :environment do
    Stripe::Transfer.create(
      :amount => (Stripe::Balance.retrieve()['available'][0].amount * 7)/100,
      :currency => "usd",
      :destination => "acct_18Gu8kBa0SNFlc27",
      :description => "Transfer for 100stategivers revenue"
    )

    Stripe::Transfer.create(
      :amount => Stripe::Balance.retrieve()['available'][0].amount ,
      :currency => "usd",
      :recipient => "self",
      :description => "Transfer for 100stategivers revenue"
    )
  end
  Stripe.api_key = ENV['STRIPE_SECRET_KEY_LIVE']
end
