class ShoppingCartsController < ApplicationController
  before_action :set_cart, only: %i[index create destroy]

  def index
    @user_cart_items = ShoppingCartItem.user_cart_items(@user_cart)
    @user_cart_items_count = ShoppingCartItem.user_cart_items(@user_cart).count
    @user_cart_item_ids = ShoppingCartItem.user_cart_item_ids(@user_cart)
    @product_names = Product.in_cart_product_names(@user_cart_item_ids)
    @total = @user_cart.total
  end

private
  def set_cart
    @user_cart = ShoppingCart.set_user_cart(current_user)
  end
end
