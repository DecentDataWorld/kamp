require "rails_helper"

describe UsersOrganizationsController do
  describe "routing" do

    it "routes to #index" do
      get("/users_organizations").should route_to("users_organizations#index")
    end

    it "routes to #new" do
      get("/users_organizations/new").should route_to("users_organizations#new")
    end

    it "routes to #show" do
      get("/users_organizations/1").should route_to("users_organizations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/users_organizations/1/edit").should route_to("users_organizations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/users_organizations").should route_to("users_organizations#create")
    end

    it "routes to #update" do
      put("/users_organizations/1").should route_to("users_organizations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/users_organizations/1").should route_to("users_organizations#destroy", :id => "1")
    end

  end
end
