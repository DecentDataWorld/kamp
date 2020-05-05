require "rails_helper"

RSpec.describe DenialReasonsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/denial_reasons").to route_to("denial_reasons#index")
    end

    it "routes to #new" do
      expect(:get => "/denial_reasons/new").to route_to("denial_reasons#new")
    end

    it "routes to #show" do
      expect(:get => "/denial_reasons/1").to route_to("denial_reasons#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/denial_reasons/1/edit").to route_to("denial_reasons#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/denial_reasons").to route_to("denial_reasons#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/denial_reasons/1").to route_to("denial_reasons#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/denial_reasons/1").to route_to("denial_reasons#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/denial_reasons/1").to route_to("denial_reasons#destroy", :id => "1")
    end

  end
end
