require 'rails_helper'

RSpec.describe 'Footer Navigation', type: :system do
  context 'when user is signed in' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

    before do
      login_as(user)
      visit root_path
    end

    it 'displays the correct footer items for signed-in users' do
      expect(page).to have_link('全ての釣果', href: catches_path)
      expect(page).to have_link('自分の釣果', href: index_user_path)
      expect(page).to have_link('自分の日記', href: diaries_path)
      expect(page).to have_link('マイページ', href: edit_user_registration_path)
    end
  end

  context 'when user is not signed in' do
    before do
      visit root_path
    end

    it 'displays the correct footer items for guests' do
      expect(page).to have_link('使い方', href: tips_path)
      expect(page).to have_link('釣果を見る', href: catches_path)
      expect(page).to have_link('新規登録', href: new_user_registration_path)
      expect(page).to have_link('ログイン', href: new_user_session_path)
    end
  end
end
