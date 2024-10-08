require 'rails_helper'

RSpec.describe 'Header Navigation', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  context 'when user is not signed in' do
    it 'displays header menu and allows navigation to the terms, privacy policy, and inquiry pages' do
      visit root_path

      expect(page).to have_selector('header')

      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click

      click_link '利用規約'
      expect(page).to have_current_path(terms_path)

      visit root_path
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      click_link 'プライバシーポリシー'
      expect(page).to have_current_path(privacy_policy_path)

      visit root_path
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      link = find_link('問い合わせ')[:href]
      expect(link).to match(/google.com\/forms/)
    end
  end

  context 'when user is signed in' do
    before do
      login_as(user, scope: :user)
    end

    it 'displays header menu and allows logout' do
      visit root_path
      expect(page).to have_selector('header')
      find('button[data-dropdown-toggle="dropdownDotsHorizontal"]').click
      expect(page).to have_link('ログアウト')
      click_link 'ログアウト'
      expect(page).to have_content('ログアウトしました')
    end
  end
end
