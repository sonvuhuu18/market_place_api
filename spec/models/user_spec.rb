require 'rails_helper'

RSpec.describe User, type: :model do
  before {@user = FactoryGirl.build :user}
  subject {@user}
  it {is_expected.to validate_presence_of :email}
  it {is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity}
  it {is_expected.to validate_confirmation_of :password}
  it {is_expected.to allow_value("example@framgia.com").for :email}

  it {is_expected.to be_valid}
end
