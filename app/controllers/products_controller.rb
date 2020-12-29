class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    @product.category_id = 1 #sample_code
    @product.save #save in db
    redirect_to product_url @product
  end

  def edit
  end

  def update
  end

  def destroy
  end

 private
  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end
