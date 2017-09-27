require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #show" do
    before :each do
      @product = FactoryGirl.create :product
      get :show, params: {id: @product.id}
    end

    it "returns the information about a reporter on a hash" do
      products_response = json_response
      expect(products_response[:title]).to eql @product.title
    end

    it {is_expected.to respond_with 200}
  end

  describe "GET #index" do
    before :each do
      4.times {FactoryGirl.create :product}
      get :index
    end

    it "returns 4 records from the database" do
      products_response = json_response
      expect(products_response.size).to eql 4
    end

    it {is_expected.to respond_with 200}
  end

  describe "POST #create" do
    before do
      @user = FactoryGirl.create :user
    end

    context "successfully created" do
      before :each do
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header @user.auth_token
        post :create, params: {user_id: @user.id, product: @product_attributes}
      end

      it "renders the json representation for the product record just created" do
        products_response = json_response
        expect(products_response[:title]).to eql @product_attributes[:title]
      end

      it {is_expected.to respond_with 201}
    end

    context "failed created" do
      before :each do
        @invalid_product_attributes = {title: "Abc", price: -100}
        api_authorization_header @user.auth_token
        post :create, params: {user_id: @user.id, product: @invalid_product_attributes}
      end

      it "" do
        products_response = json_response
        expect(products_response[:errors][:price]).to eql ["must be greater than or equal to 0"]
      end

      it {is_expected.to respond_with 422}
    end
  end

  describe "PUT/PATCH #update" do
    before do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "successfully updated" do
      before :each do
        patch :update, params: {id: @product.id, user_id: @user.id,
          product: {title: "Abc"}}
      end

      it "" do
        products_response = json_response
        expect(products_response[:title]).to eql "Abc"
      end

      it {is_expected.to respond_with 201}
    end

    context "failed updated" do
      before :each do
        patch :update, params: {id: @product.id, user_id: @user.id,
          product: {price: -100}}
      end

      it "" do
        products_response = json_response
        expect(products_response).to have_key(:errors)
      end

      it {is_expected.to respond_with 422}
    end
  end

  describe "DELETE #destroy" do
    before do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, params: {id: @product.id, user_id: @user.id}
    end

    it {is_expected.to respond_with 204}
  end
end
