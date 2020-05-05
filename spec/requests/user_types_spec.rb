require 'rails_helper'

describe "UserTypes" do
  describe "GET /user_types" do
    it "redirects if not authorized" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_types_path
      response.status.should be(302)
    end
  end
end
