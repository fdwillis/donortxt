require "active_support"

@crypt = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE'])

namespace :tasks do

  desc "Create Recipients"
  task merchant_ready: :environment do
    User.all.each do |user|
      @user = if user.merchant_ready? && !user.stripe_account_id?
        
        puts 'send an email'
      end
    end
    puts "#{@user}"
  end
end

namespace :keen do
	desc "Keen"
	task  keen: :environment do
		@order = Order.first
		Keen.publish("Orders", {
				marketplace_name: "MarketplaceBase",
				#IP
				#city
				#state
				#country
				#year
				#month
				#day
				#hour
				#minute
				merchant_id: @order.merchant_id,
				customer_id: @order.user_id,
				total_price: @order.total_price.to_f,
				shipping_price: @order.shipping_price.to_f,
				customer_sign_in_count: @order.user.sign_in_count,
				order_uuid: @order.uuid,
				submit_timestamp: @order.updated_at
			})
		@order.order_items.each do |oi|
			Keen.publish("Order Items", {
				marketplace_name: "MarketplaceBase",
				product_tags: oi.product_tags,
				price: oi.price.to_f,
				quantity: oi.quantity,
				total_price: oi.total_price.to_f,
				product_uuid: oi.product_uuid,
				order_uuid: oi.order.uuid,
				shipping_price: oi.shipping_price.to_f,
				merchant_id: @order.merchant_id,
				order_item_id: oi.id,
				order_total_price: oi.total_price,
				})
		end
		@order.order_items.each do |oi|
			Product.find_by(uuid: oi.product_uuid).tags.each do |tag|
				Keen.publish("Tags On Ordered Items", {
					marketplace_name: "MarketplaceBase",
					tag: tag.name, 
					order_uuid: oi.order.uuid, 
					order_item_id: oi.id,
					order_item_product_uuid: oi.product_uuid,
					order_total_price: oi.order.total_price.to_f,
					order_item_total_price: oi.total_price.to_f, 
					})
			end
		end
	end
	puts "sent to keen"
end


# Most And Least Used Tags
# ActsAsTaggableOn::Tag.most_used
# ActsAsTaggableOn::Tag.least_used
