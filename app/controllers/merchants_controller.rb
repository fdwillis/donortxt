class MerchantsController < ApplicationController
  before_filter :authenticate_user!
  def index
    no_buyers = User.joins(:roles).where.not(roles: {title: 'buyer'})
    @accounts = no_buyers.where(account_approved: true).uniq
  end

  def pending
    @crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
    if current_user.admin? 
      no_buyers = User.joins(:roles).where.not(roles: {title: 'buyer'})
      @pending = no_buyers.where(account_approved: false).uniq
    else
      redirect_to root_path
      flash[:error] = "You Don't Have Permission To Access That Page"
    end
  end

  def show
    #Track for Merchant and Admin
    @name = User.friendly.find(params[:id]).username
    
    if User.friendly.find(params[:id]).account_approved? || User.friendly.find(params[:id]).admin?
      @merchant = User.friendly.find(params[:id])
      # if current_user != @merchant || !current_user
      #   if current_user
      #     User.profile_views(current_user.id, request.remote_ip, request.location.data, @merchant)
      #   else
      #     User.profile_views(0, request.remote_ip, request.location.data, @merchant)
      #   end
      # end
    else
      redirect_to root_path
      flash[:error] = "#{@name} is no longer fundraising"
    end
  end

  def approved_accounts
    @crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])
    if current_user.admin?
      @approved_accounts = User.all.where(account_approved: true)
    else
      redirect_to root_path
      flash[:error] = "You Don't Have Permission To Access That Page"
    end
  end

  def approve_account
    @account = User.find(params[:id])
    @account.update_attributes(account_approved: true )
    Keen.publish("Sign Ups", {
      user_id: @account.id,
      year: Time.now.strftime("%Y").to_i,
      month: DateTime.now.to_date.strftime("%B"),
      day: Time.now.strftime("%d").to_i,
      day_of_week: DateTime.now.to_date.strftime("%A"),
      hour: Time.now.strftime("%H").to_i,
      minute: Time.now.strftime("%M").to_i,
      timestamp: Time.now,
      marketplace_name: ENV["MARKETPLACE_NAME"]
    })
    redirect_to merchants_path
    email = Notify.account_approved(@account).deliver_now
    flash[:notice] = "#{@account.username.capitalize}'s Account Was Approved"
  end
end
