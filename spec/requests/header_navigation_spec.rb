require 'rails_helper'

RSpec.describe "Header Navigation", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  describe "GET root_path" do
    it "displays the logo and banner" do
      get root_path
      expect(response.body).to include('Fishingram Logo')
      expect(response.body).to include('Fishingram Banner')
    end
  end

  describe "GET /terms" do
    it "navigates to the terms page" do
      get terms_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('利用規約')
    end
  end

  describe "GET /privacy_policy" do
    it "navigates to the privacy policy page" do
      get privacy_policy_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('プライバシーポリシー')
    end
  end

  describe "External link for inquiries" do
    it "contains the correct link to the Google Form for inquiries" do
      get root_path
      expect(response.body).to include('https://docs.google.com/forms/d/e/1FAIpQLSfo8LgIDTyXKO3_wR37ONSLzs22f3wBH7_B1SWHbex0SJQOOA/viewform')
    end
  end

  describe "User logout" do
    context "when logged in" do
      before { sign_in user }

      it "displays the logout link" do
        get root_path
        expect(response.body).to include('ログアウト')
      end

      it "logs out the user when the logout link is clicked" do
        delete destroy_user_session_path
        follow_redirect!
        get root_path
        expect(response.body).not_to include('ログアウト')
      end
    end

    context "when not logged in" do
      it "does not display the logout link" do
        get root_path
        expect(response.body).not_to include('ログアウト')
      end
    end
  end
end
