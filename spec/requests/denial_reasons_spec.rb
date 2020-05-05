require 'rails_helper'

RSpec.describe "DenialReasons", type: :request do
  describe "GET /denial_reasons" do
    it "redirects if not authorized" do
      get denial_reasons_path
      expect(response).to have_http_status(302)
    end
  end
end
