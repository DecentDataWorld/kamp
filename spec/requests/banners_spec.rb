require 'rails_helper'

RSpec.describe "Banners", type: :request do
  describe "GET /banners" do
    it "redirects if not authorized" do
      get banners_path
      expect(response).to have_http_status(302)
    end
  end
end
