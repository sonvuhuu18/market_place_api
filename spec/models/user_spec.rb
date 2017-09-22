require 'rails_helper'

RSpec.describe User, type: :model do
  before {@user = FactoryGirl.build :user}
  subject {@user}
  it {is_expected.to validate_presence_of :email}
  it {is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity}
  it {is_expected.to validate_confirmation_of :password}
  it {is_expected.to allow_value("example@framgia.com").for :email}
  it {is_expected.to respond_to :auth_token}
  it {is_expected.to validate_uniqueness_of(:auth_token).ignoring_case_sensitivity}

  describe "#generate_authentication_token" do
    it "generate an unique token" do
      allow(Devise).to receive(:friendly_token).and_return("uniquetoken")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "uniquetoken"
    end

    it "generates another token when one already has been taken" do
      another_user = FactoryGirl.create :user, auth_token: "uniquetoken"
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql another_user.auth_token
    end
  end

  it {is_expected.to be_valid}
end
