class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews
  acts_as_likeable

  PER = 15

  scope :display_list, -> (category, page) {
    if category != "none"
      where(category_id: category).page(page).per(PER)
    else
      page(page).per(PER)
    end
  }

  scope :sort_list, -> {
    {
      "並び替え" => "",
      "価格の安い順" => "price asc",
      "価格の高い順" => "price desc",
      "出品の古い順" => "update_at asc",
      "出品の新しい順" => "update_at desc",
    }
  }

  def reviews_new
    reviews.new
  end
end
