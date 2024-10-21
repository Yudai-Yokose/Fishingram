require 'rails_helper'

RSpec.describe "Catches", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！') }

  describe "ログインしていない場合" do
    it "編集時にログインページにリダイレクトされること" do
      get edit_catch_path(catch)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "更新時にログインページにリダイレクトされること" do
      patch catch_path(catch), params: { catch: { memo: "Updated memo" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "削除時にログインページにリダイレクトされること" do
      delete catch_path(catch)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "ログインしている場合" do
    before do
      sign_in user
    end

    it "表示アクションで釣果が表示されること" do
      get catch_path(catch)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(catch.memo)
    end

    it "編集アクションで編集フォームが表示されること" do
      get edit_catch_path(catch)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('form')
    end

    it "正しいユーザーによって釣果が更新されること" do
      patch catch_path(catch), params: { catch: { memo: "Updated memo" } }
      expect(response).to redirect_to(catch_path(catch))
      follow_redirect!
      expect(response.body).to include("Updated memo")
    end

    it "正しいユーザーによって釣果が削除されること" do
      expect {
        delete catch_path(catch)
      }.to change(Catch, :count).by(-1)
      expect(response).to redirect_to(catches_path)
    end
  end

  describe "異なるユーザーでログインしている場合" do
    before do
      sign_in other_user
    end

    it "編集時に釣果一覧にリダイレクトされること" do
      get edit_catch_path(catch)
      expect(response).to redirect_to(catches_path)
    end

    it "更新時に釣果一覧にリダイレクトされること" do
      patch catch_path(catch), params: { catch: { memo: "Unauthorized update" } }
      expect(response).to redirect_to(catches_path)
    end

    it "削除時に釣果一覧にリダイレクトされること" do
      expect {
        delete catch_path(catch)
      }.not_to change(Catch, :count)
      expect(response).to redirect_to(catches_path)
    end
  end
end
