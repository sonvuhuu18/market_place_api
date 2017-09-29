class Product < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0},
    presence: true

  belongs_to :user
  scope :filter_by_title, -> (keyword) do
    where("lower(title) LIKE ?", "%#{keyword.downcase}%")
  end
  scope :above_or_equal_to_price, -> (price) do
    where("price >= ?", price)
  end
  scope :below_or_equal_to_price, -> (price) do
    where("price <= ?", price)
  end
  scope :most_recent, -> () do
    order :updated_at
  end

  class << self
    def search params = {}
      if params[:product_ids].present?
        products = Product.find params[:product_ids]
      else
        products = Product.all
      end
      products = products.filter_by_title(params[:title]) if params[:title]
      products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price]
      products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price]

      products
    end
  end
end
