require 'rails_helper'

describe "Organizations" do
  describe "GET /organizations" do
    it "redirects if not authorized" do
      # TODO - Requires sunspot
      # get organizations_path
      # response.status.should be(302)
    end
  end
end
