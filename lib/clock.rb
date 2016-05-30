require 'clockwork'
require './config/boot'
require './config/environment'
module Clockwork
  handler do |job|
    puts "Running #{job}"
  end
  
  every(1.week, 'Payroll', at: 'Friday 00:00') {
    `rake payout:all`
  }

end