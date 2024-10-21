require 'rails_helper'

RSpec.describe 'ヘッダー ナビゲーション', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', username: 'adminuser', admin: true) }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)
  end

  context 'ユーザーがサインインしていない場合' do
    it 'ヘッダーメニューを表示し、利用規約、プライバシーポリシー、お問い合わせページへのナビゲーションを許可すること' do
      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      click_link '利用規約'
      expect(page).to have_current_path(terms_path)

      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      click_link 'プライバシーポリシー'
      expect(page).to have_current_path(privacy_policy_path)

      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      link = find_link('問い合わせ')[:href]
      expect(link).to match(/google.com\/forms/)
    end
  end

  context 'ユーザーがサインインしている場合' do
    before do
      login_as(user, scope: :user)
    end

    it 'ヘッダーメニューを表示し、ログアウトを許可すること' do
      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      click_link '利用規約'
      expect(page).to have_current_path(terms_path)

      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      click_link 'プライバシーポリシー'
      expect(page).to have_current_path(privacy_policy_path)

      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      link = find_link('問い合わせ')[:href]
      expect(link).to match(/google.com\/forms/)

      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      expect(page).to have_link('ログアウト')
      click_link 'ログアウト'
      expect(page).to have_content(I18n.t("devise.sessions.signed_out"))
    end

    it 'ダッシュボードへのアクセスを試みると、アクセス権限がないことを確認する' do
      visit admin_dashboard_path
      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t("activerecord.attributes.user.not_admin"))
    end

    context '管理者ユーザーの場合' do
      before do
        login_as(admin_user, scope: :user)
      end

      it 'ダッシュボードにアクセスできること' do
        visit root_path
        expect(page).to have_selector('header')
        find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click

        expect(page).to have_link('Admin Dashboard')
        expect(page).to have_content('Admin Dashboard')
      end
    end
  end
end
