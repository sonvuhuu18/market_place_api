require 'rails_helper'

describe ApiConstraints do
  let(:api_constraints_v1) do
    ApiConstraints.new(version: 1)
  end
  let(:api_constraints_v2) do
    ApiConstraints.new(version: 2, default: true)
  end

  describe "matches?" do

    it "returns true when the version matches the 'Accept' header" do
      request = double(host: 'api.marketplace.dev',
        headers: {"Accept" => "application/vnd.marketplace.v1"})
      api_constraints_v1.matches?(request).should be_truthy
    end

    it "returns the default version when 'default' option is specified" do
      request = double(host: 'api.market_place_api.127.0.0.1.xip.io/')
      api_constraints_v2.matches?(request).should be_truthy
    end
  end
end
