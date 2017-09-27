require "rails_helper"

class Authentication < ActionController::Base
  include Authenticable

  def response
  end

  def request
  end
end

RSpec.describe Authenticable do
  let(:authentication) {Authentication.new}
  subject{authentication}

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe "#authenticable_with_token" do
    before do
      @user = FactoryGirl.create :user
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return(
        {"errors" => "Not authenticated"}.to_json
      )
      allow(authentication).to receive(:request).and_return(request)
    end

    it "render a json error message" do
      expect(json_response[:errors]).to eql "Not authenticated"
    end

  end

  describe "#current_user" do
    context "when there is a user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(@user)
      end
      it {is_expected.to be_user_signed_in}
    end

    context "when there is no user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(nil)
      end
      it {is_expected.not_to be_user_signed_in}
    end
  end
end
