require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) {FactoryGirl.build :product}
  subject {product}

  it {is_expected.to respond_to(:title)}
  it {is_expected.to respond_to(:price)}
  it {is_expected.to respond_to(:published)}
  it {is_expected.to respond_to(:user_id)}

  it {is_expected.not_to be_published}

  it {is_expected.to validate_presence_of :title}
  it {is_expected.to validate_presence_of :price}
  it {is_expected.to validate_presence_of :user_id}
  it {is_expected.to validate_numericality_of(:price).
    is_greater_than_or_equal_to 0}

  it {should belong_to :user}

  describe ".filter_by_title" do
    before do
      @product1 = FactoryGirl.create :product, title: "Plasma TV"
      @product2 = FactoryGirl.create :product, title: "CD Player"
      @product3 = FactoryGirl.create :product, title: "OLED TV"
    end

    it "" do
      products = Product.filter_by_title("TV")
      expect(products.size).to eql 2
    end

    it "" do
      products = Product.filter_by_title("TV")
      expect(products.sort).to match_array([@product1, @product3])
    end
  end

  describe ".above_or_equal_to_price" do
    before do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 200
      @product3 = FactoryGirl.create :product, price: 300
      @product4 = FactoryGirl.create :product, price: 400
    end

    it "" do
      products = Product.above_or_equal_to_price 300
      expect(products.size).to eql 2
      expect(products.sort).to match_array [@product3, @product4]
    end

    it "" do
      products = Product.below_or_equal_to_price 200
      expect(products.size).to eql 2
      expect(products.sort).to match_array [@product1, @product2]
    end
  end

  describe ".most_recent" do
    before do
      @product1 = FactoryGirl.create :product
      @product2 = FactoryGirl.create :product
      @product3 = FactoryGirl.create :product
      @product4 = FactoryGirl.create :product
      @product3.touch
      @product2.touch
    end

    it "" do
      products = Product.most_recent
      expect(products).to match_array [@product2, @product3, @product4, @product1]
    end
  end

  describe ".search" do
    before do
      @product1 = FactoryGirl.create :product, title: "Plasma TV", price: 100
      @product2 = FactoryGirl.create :product, title: "OLED TV", price: 300
      @product3 = FactoryGirl.create :product, title: "CD Player", price: 50
      @product4 = FactoryGirl.create :product, title: "Console", price: 200
    end

    it "" do
      search_hash = {product_ids: [@product4.id, @product1.id]}
      products = Product.search search_hash
      expect(products).to match_array [@product4, @product1]
    end

    it "" do
      products = Product.search {}
      expect(products).to match_array [@product1, @product2, @product3, @product4]
    end

    it "" do
      search_hash = {title: "TV", min_price: 50, max_price: 200}
      products = Product.search search_hash
      expect(products).to match_array [@product1]
    end

    it "" do
      search_hash = {title: "TV", min_price: 50, max_price: 400}
      products = Product.search search_hash
      expect(products).to match_array [@product1, @product2]
    end
  end
end
