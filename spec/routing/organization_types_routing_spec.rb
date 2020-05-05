require "rails_helper"

describe OrganizationTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/organization_types").should route_to("organization_types#index")
    end

    it "routes to #new" do
      get("/organization_types/new").should route_to("organization_types#new")
    end

    it "routes to #show" do
      get("/organization_types/1").should route_to("organization_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/organization_types/1/edit").should route_to("organization_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/organization_types").should route_to("organization_types#create")
    end

    it "routes to #update" do
      put("/organization_types/1").should route_to("organization_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/organization_types/1").should route_to("organization_types#destroy", :id => "1")
    end

  end
end
