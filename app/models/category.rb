class Category < ApplicationRecord
  has_many :products
  scope :major_categories, -> { pluck(:major_category_name).uniq }
end
