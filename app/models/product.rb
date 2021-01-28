class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews
  acts_as_likeable
  has_one_attached :image

  extend DisplayList
  scope :on_category, -> (category) { where(category_id: category) }
  scope :sort_order, -> (order) { order(order) }
  #idとnameにviewで取得したkeywordに合致する値を探すscopeを定義したい。値がなければallを返す
  scope :search_for_id_and_name, -> (keyword) { where(id: keyword).or(where(name: keyword)) if keyword.present? }
  # scope :search_for_id_and_name, -> (keyword) do
  #   if keyword.present?
  #     where(id: keyword).or(where(name: keyword))
  #   else
  #     all
  #   end
  # end

  scope :category_products, -> (category, page) {
    on_category(category).
    display_list(page)
  }

  scope :sort_products, -> (sort_order, page) {
    on_category(sort_order[:sort_category]).
    sort_order(sort_order[:sort]).
    display_list(page)
  }

  scope :sort_list, -> {
    {
      "並び替え" => "",
      "価格の安い順" => "price asc",
      "価格の高い順" => "price desc",
      "出品の古い順" => "updated_at asc",
      "出品の新しい順" => "updated_at desc",
    }
  }

  scope :in_cart_product_names, -> (cart_item_ids) { where(id: cart_item_ids).pluck(:name) }
  scope :recently_products, -> (number) { order(created_at: "desc").take(number) }
  scope :recommend_products, -> (number) { where(recommend_flag: true).take(number) }
  scope :check_products_carriage_list, -> (product_ids) { where(id: product_ids).pluck(:carriage_flag)}

  def reviews_new
    reviews.new
  end

  def reviews_with_id
    reviews.reviews_with_id
  end
end
