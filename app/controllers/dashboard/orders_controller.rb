class Dashboard::OrdersController < ApplicationController
  before_action :authenticate_admin!
  layout "dashboard/dashboard"

  def index
    code = params[:code].present? ? params[:code] : ""
    @orders = code.present? ? ShoppingCart.get_orders({code: code}) : ShoppingCart.get_orders
    @orders_array = Kaminari.paginate_array(@orders.to_a).page(params[:page]).per(15)
    @total = @orders.count
  end
end
