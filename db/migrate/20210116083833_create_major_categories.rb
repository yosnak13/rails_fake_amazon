class CreateMajorCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :major_categories do |t|

      t.timestamps
    end
  end
end
