require 'rails_helper'

RSpec.describe "Header Navigation", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', username: 'adminuser', admin: true) }

  describe "GET root_path" do
    it "ロゴとバナーが表示されること" do
      get root_path
      expect(response.body).to include('Fishingram Logo')
      expect(response.body).to include('Fishingram Banner')
    end
  end

  describe "GET /terms (利用規約)" do
    it "利用規約ページに移動すること" do
      get terms_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('利用規約')
    end
  end

  describe "GET /privacy_policy (プライバシーポリシー)" do
    it "プライバシーポリシーページに移動すること" do
      get privacy_policy_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('プライバシーポリシー')
    end
  end

  describe "問い合わせのための外部リンク" do
    it "問い合わせ用のGoogleフォームへの正しいリンクを含むこと" do
      get root_path
      expect(response.body).to include('https://docs.google.com/forms/d/e/1FAIpQLSfo8LgIDTyXKO3_wR37ONSLzs22f3wBH7_B1SWHbex0SJQOOA/viewform')
    end
  end

  describe "ユーザーのログアウト" do
    context "ログインしている場合" do
      before { sign_in user }

      it "ログアウトリンクが表示されること" do
        get root_path
        expect(response.body).to include('ログアウト')
      end

      it "ログアウトリンクがクリックされたときにユーザーがログアウトすること" do
        delete destroy_user_session_path
        follow_redirect!
        get root_path
        expect(response.body).not_to include('ログアウト')
      end
    end

    context "ログインしていない場合" do
      it "ログアウトリンクが表示されないこと" do
        get root_path
        expect(response.body).not_to include('ログアウト')
      end
    end
  end

  describe "管理ダッシュボードへのアクセス" do
    context "ユーザーが管理者の場合" do
      before { sign_in admin_user }

      it "管理ダッシュボードにアクセスできること" do
        get admin_dashboard_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーが管理者でない場合" do
      before { sign_in user }

      it "ルートページにリダイレクトされること" do
        get admin_dashboard_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("activerecord.attributes.user.not_admin"))
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get admin_dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
