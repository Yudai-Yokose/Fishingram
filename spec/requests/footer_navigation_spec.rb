require 'rails_helper'

RSpec.describe "Footer Navigation", type: :request do
  let(:user) { create(:user) }

  describe "GET /catches (全ての釣果)" do
    context "when user is logged in" do
      before do
        sign_in user
      end

      it "returns a successful response" do
        get catches_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not logged in" do
      it "returns a successful response" do
        get catches_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /index_user (自分の釣果)" do
    context "when user is logged in" do
      before do
        sign_in user
      end

      it "returns a successful response" do
        get index_user_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get index_user_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /diaries (自分の日記)" do
    context "when user is logged in" do
      before do
        sign_in user
      end

      it "returns a successful response" do
        get diaries_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get diaries_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /new_user_session (ログイン)" do
    it "returns a successful response" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new_user_registration (新規登録)" do
    it "returns a successful response" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end
end
