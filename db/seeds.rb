account = Stripe::Account.create(
  managed: true,
  country: "US",
  email: "fdwillis7@gmail.com",
  business_name: "Hacknvest LLC",
  debit_negative_balances: true,
  external_account: {
    object: 'bank_account',
    country: "US",
    currency: "usd",
    routing_number: "110000000",
    account_number: "000123456789",
    # routing_number: "275979076",
    # account_number: "0430852605",
  },
  tos_acceptance: {
    ip: "64.7.13.8",
    date: Time.now.to_i,
    user_agent: "chrome",
  },
  legal_entity: {
    type: "company",
    business_name: "Hacknvest LLC",
    first_name: "Frederick",
    last_name: "Willis",
    business_tax_id: "393112502",
    dob: {
      day: "31",
      month: "12",
      year: "1992",
    },
    address: {
      line1: "526 west wilson",
      city: "Madison",
      state: "WI",
      postal_code: "53703",
      country: "US",
    }
  },
  decline_charge_on: {
    cvc_failure: true,
  },
  transfer_schedule: {
    interval: 'manual',
  },
)