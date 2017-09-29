require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) do
    request.headers['Accept'] = "application/vnd.marketplace.v1",
      "#{Mime[:json]}"
  end
  before(:each) {request.headers['Content-Type'] = Mime[:json].to_s}

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, params: {id: @user.id}
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it "" do
      user_response = json_response
      expect(user_response[:product_ids]).to eql []
    end

    it {is_expected.to respond_with 200}
  end

  describe "POST #create" do
    context "successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: {user: @user_attributes}
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it {is_expected.to respond_with 201}
    end

    context "failed created" do
      before(:each) do
        @invalid_user_attributes = {password: "123456", password_confirmation: "123456"}
        post :create, params: {user: @invalid_user_attributes}, format: :json
      end

      it "renders an error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it {is_expected.to respond_with 422}
    end
  end

  describe "PUT/PATCH #update" do
    before :each do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
    end
    context "successfully updated" do
      before(:each) do
        patch :update, params: {id: @user.id, user: {email: "abc@gmail.com"}}
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "abc@gmail.com"
      end

      it {is_expected.to respond_with 200}
    end

    context "failed update" do
      before(:each) do
        patch :update, params: {id: @user.id, user: {email: "abc"}}
      end

      it "renders an error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it {is_expected.to respond_with 422}
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, params: {id: @user.id}
    end

    it {is_expected.to respond_with 204}
  end
end
