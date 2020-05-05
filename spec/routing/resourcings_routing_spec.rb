require "rails_helper"

describe ResourcingsController do
  describe "routing" do

    it "routes to #index" do
      get("/resourcings").should route_to("resourcings#index")
    end

    it "routes to #new" do
      get("/resourcings/new").should route_to("resourcings#new")
    end

    it "routes to #show" do
      get("/resourcings/1").should route_to("resourcings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/resourcings/1/edit").should route_to("resourcings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/resourcings").should route_to("resourcings#create")
    end

    it "routes to #update" do
      put("/resourcings/1").should route_to("resourcings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/resourcings/1").should route_to("resourcings#destroy", :id => "1")
    end

  end
end
