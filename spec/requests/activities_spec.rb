require 'rails_helper'

describe "Activities" do
  describe "GET /activities" do
    it "works!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get activities_path
      response.status.should be(200)
    end
  end
end
