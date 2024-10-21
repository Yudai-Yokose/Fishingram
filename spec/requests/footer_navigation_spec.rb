require 'rails_helper'

RSpec.describe "Footer Navigation", type: :request do
  let(:user) { create(:user) }

  describe "GET /catches (全ての釣果)" do
    context "ユーザーがログインしている場合" do
      before do
        sign_in user
      end

      it "成功のレスポンスを返すこと" do
        get catches_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "成功のレスポンスを返すこと" do
        get catches_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /index_user (自分の釣果)" do
    context "ユーザーがログインしている場合" do
      before do
        sign_in user
      end

      it "成功のレスポンスを返すこと" do
        get index_user_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get index_user_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /diaries (自分の日記)" do
    context "ユーザーがログインしている場合" do
      before do
        sign_in user
      end

      it "成功のレスポンスを返すこと" do
        get diaries_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get diaries_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /new_user_session (ログイン)" do
    it "成功のレスポンスを返すこと" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new_user_registration (新規登録)" do
    it "成功のレスポンスを返すこと" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end
end
