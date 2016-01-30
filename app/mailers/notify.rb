class Notify < ApplicationMailer
	default from: "#{ENV['MARKETPLACE_NAME'].gsub(' ', '').downcase}team@#{ENV['MARKETPLACE_NAME'].gsub(' ', '').downcase}.com", return_path: 'fdwillis7@gmail.com'

  def account_approved(user)
    @user = user
    if !@user.admin?  
      @mail = mail(to: user.email, subject: "Fundraising Account Approved") do |format|
        format.html
      end
    end
  end

  def email_blast(sender_email, emails, subject, body)
    @body = body
    emails.each do |email|
      @email = email
      @mail = mail(from: sender_email, to: email, subject: subject) do |format|
        format.html
      end
    end
  end

  def donation_canceled(raiser, canceled_donor, amount)
    @canceled_donor = canceled_donor
    @raiser = raiser
    @amount = (amount.to_f / 100)
    @mail = mail(to: raiser.email, subject: "Canceled Subscription") do |format|
      format.html
    end
  end
end
