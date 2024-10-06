require 'rails_helper'

RSpec.describe "Catches", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！') }

  describe "when not logged in" do
    it "redirects to the login page for edit" do
      get edit_catch_path(catch)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects to the login page for update" do
      patch catch_path(catch), params: { catch: { memo: "Updated memo" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects to the login page for destroy" do
      delete catch_path(catch)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when logged in" do
    before do
      sign_in user
    end

    it "shows the catch for show action" do
      get catch_path(catch)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(catch.memo)
    end

    it "renders the edit form for edit action" do
      get edit_catch_path(catch)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('form')
    end

    it "updates the catch for the correct user" do
      patch catch_path(catch), params: { catch: { memo: "Updated memo" } }
      expect(response).to redirect_to(catch_path(catch))
      follow_redirect!
      expect(response.body).to include("Updated memo")
    end

    it "deletes the catch for the correct user" do
      expect {
        delete catch_path(catch)
      }.to change(Catch, :count).by(-1)
      expect(response).to redirect_to(catches_path)
    end
  end

  describe "when logged in as a different user" do
    before do
      sign_in other_user
    end

    it "redirects to the catches index for edit" do
      get edit_catch_path(catch)
      expect(response).to redirect_to(catches_path)
    end

    it "redirects to the catches index for update" do
      patch catch_path(catch), params: { catch: { memo: "Unauthorized update" } }
      expect(response).to redirect_to(catches_path)
    end

    it "redirects to the catches index for destroy" do
      expect {
        delete catch_path(catch)
      }.not_to change(Catch, :count)
      expect(response).to redirect_to(catches_path)
    end
  end
end
