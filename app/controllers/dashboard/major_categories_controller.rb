class Dashboard::MajorCategoriesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_major_category, only: %w[show edit update destroy]
  layout "dashboard/dashboard"

  def index
    @major_categories = MajorCategory.display_list(params[:pages])
  end

  def show
  end

  def create
    major_category = MajorCategory.new(major_category_params)
    major_category.save
    redirect_to dashboard_major_categories_path
  end

  def edit
  end

  def destroy
    @major_category.destroy
    redirect_to dashboard_major_categories_path
  end

private
  def major_category_params
    # params.require(:major_category).permit(:name, :description)
    params.permit(:name, :description)
  end
end
