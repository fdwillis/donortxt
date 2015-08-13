class MerchantsController < ApplicationController
  def index
    no_buyers = User.all.where.not(role:'buyer')
    @merchants = no_buyers.where(merchant_approved: true)
    @pending = no_buyers.where(merchant_approved: false)
  end

  def show
    #Track for Merchant and Admin
    @name = User.friendly.find(params[:id]).name
    if User.friendly.find(params[:id]).merchant?
      @merchant = User.friendly.find(params[:id])
      @products = @merchant.products.where(active:true)
    else
      redirect_to root_path
      flash[:error] = "#{@name} is no longer selling items"
    end
  end

  def approve_merchant
    @merchant = User.find_by(username: params[:username])
    @merchant.update_attributes(merchant_approved: true )
    redirect_to merchants_path
    flash[:notice] = "Merchant #{@merchant.username} Was Approved"
  end
end
