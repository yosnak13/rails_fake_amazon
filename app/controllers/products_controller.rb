class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
