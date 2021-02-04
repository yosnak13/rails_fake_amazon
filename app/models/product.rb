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

  def self.import_csv(file)
    new_products = []
    update_products = []
    CSV.foreach(file.path, headers: true, encoding: "Shift_JIS:UTF-8") do |row|
      row_to_hash = row.to_hash
      if row_to_hash[:id].present?
        update_product = find(id: row_to_hash[:id])
        update_product.attributes = row_to_hash.slice!(csv_attributes)
        update_products << update_product
      else
        new_product = new
        new_product.attributes = row.to_hash.slice!(csv_attributes)
        new_products << new_product
      end
    end
    if update_products.present?
      import update_products, on_duplicate_key_update: csv_attributes
    elsif
      import new_products
    end
  end

  def self.pluck_id_name_shipping_cost_flag_list(bought_cart_items)
    item_ids = bought_cart_items.map do |bought_cart_item|
      bought_cart_item.item_id
    end
    Product.where(id: item_ids).where(carriage_flag: true).pluck(:id, :name)
  end

  def reviews_new
    reviews.new
  end

  def reviews_with_id
    reviews.reviews_with_id
  end

private
  def self.csv_attributes
    [:name, :description, :price, :recommend_flag, :carriage_flag]
  end
end
