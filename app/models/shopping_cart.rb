class ShoppingCart < ApplicationRecord
  acts_as_shopping_cart

  scope :set_user_cart, -> (user) { user_cart = where(user_id: user.id, buy_flag: false)&.last
                               user_cart.nil? ? ShoppingCart.create(user_id: user.id)
                                              : user_cart }
  scope :bought_cart_ids, -> { where(buy_flag: true).pluck(:id) }

  CARRIAGE=800
  FREE_SHIPPING=0

  def self.get_monthly_billings
    buy_ids = bought_cart_ids
    return if buy_ids.nil?
    billings = ShoppingCartItem.bought_items(buy_ids).order_updated_at_desc
    hash = Hash.new { |h,k| h[k] = {} }

    billings.each_with_index do |b,i|
      if i == 0
        hash[b.updated_at.strftime("%Y-%m")][:quantity_daily] = b.quantity
      end
      if hash[b.updated_at.strftime("%Y-%m")][:price_daily].present?
        hash[b.updated_at.strftime("%Y-%m")][:price_daily] = hash[b.updated_at.strftime("%Y-%m")][:price_daily] + b.price_cents
        hash[b.updated_at.strftime("%Y-%m")][:quantity_daily] = hash[b.updated_at.strftime("%Y-%m")][:quantity_daily]  + b.quantity
        hash[b.updated_at.strftime("%Y-%m")][:price_average_daily] = hash[b.updated_at.strftime("%Y-%m")][:price_average_daily] + b.price_cents
      else
        hash[b.updated_at.strftime("%Y-%m")][:price_daily] = b.price_cents
        hash[b.updated_at.strftime("%Y-%m")][:quantity_daily] = b.quantity
        hash[b.updated_at.strftime("%Y-%m")][:price_average_daily] = b.price_cents
      end
      if i == billings.size - 1
        hash[b.updated_at.strftime("%Y-%m")][:price_average_daily] = hash[b.updated_at.strftime("%Y-%m")][:price_average_daily].to_f / billings.count
      end
    end
    return hash
  end

  def self.get_daily_billings
    buy_ids = bought_cart_ids
    return if buy_ids.nil?
    billings = ShoppingCartItem.bought_items(buy_ids).order_updated_at_desc
    hash = Hash.new { |h,k| h[k] = {} }

    billings.each_with_index do |b,i|
      if i == 0
        hash[b.updated_at.to_date.to_s][:quantity_daily] = b.quantity
      end
      if hash[b.updated_at.to_date.to_s][:price_daily].present?
        hash[b.updated_at.to_date.to_s][:price_daily] = hash[b.updated_at.to_date.to_s][:price_daily] + b.price_cents
        hash[b.updated_at.to_date.to_s][:quantity_daily] = hash[b.updated_at.to_date.to_s][:quantity_daily] + b.quantity
        hash[b.updated_at.to_date.to_s][:price_average_daily] = hash[b.updated_at.to_date.to_s][:price_daily].to_f / hash[b.updated_at.to_date.to_s][:quantity_daily]
      else
        hash[b.updated_at.to_date.to_s][:price_daily] = b.price_cents
        hash[b.updated_at.to_date.to_s][:quantity_daily] = b.quantity
        hash[b.updated_at.to_date.to_s][:price_average_daily] = b.price_cents.to_f / hash[b.updated_at.to_date.to_s][:quantity_daily]
      end
    end
    return hash
  end

  scope :sort_list, -> {
    {
      "月別" => "month",
      "日別" => "",
    }
  }

  def tax_pct
    0
  end

  def shipping_cost(cost_flag = {})
    cost_flag.present? ? Money.new(CARRIAGE * 100) #acts_as_shopping_cartはUSドル計算のため、単位を100倍する
                       : Money.new(FREE_SHIPPING)
  end

  def shipping_cost_check(user)
    cart_id = ShoppingCart.set_user_cart(user)
    product_ids = ShoppingCartItem.keep_item_ids(cart_id)
    check_products_carriage_list = Product.check_products_carriage_list(product_ids)
    check_products_carriage_list.include?("true") ? shipping_cost({cost_flag: true})
                                                  : shipping_cost
  end
end
