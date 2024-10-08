require 'rails_helper'

RSpec.describe 'Like System', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }

  # 自分の投稿
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！') }

  # 他ユーザーの投稿
  let!(:other_catch) { Catch.create!(user: other_user, tide: '小潮', tide_level: '干潮前後', range: 'ボトム', size: '50~60cm', memo: '素晴らしい釣果！') }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)
  end

  before do
    login_as(user, scope: :user)
  end

  context 'for own catch' do
    before do
      visit catches_path
      within("turbo-frame#catch_#{catch.id}") do
        find("div.block[role='button']").click
      end
    end

    it 'allows a logged-in user to like and unlike their own catch with button state changes' do
      within "turbo-frame#like_button_#{catch.id}" do
        expect(page).to have_selector("a.likeButton", count: 1)
        expect(page).not_to have_css("a.liked")

        find("a.likeButton").click
        expect(page).to have_css("a.liked")
      end

      within "turbo-frame#like_button_#{catch.id}" do
        find("a.liked").click
        expect(page).not_to have_css("a.liked")
      end
    end
  end

  context 'for another user\'s catch' do
    before do
      visit catches_path
      within("turbo-frame#catch_#{other_catch.id}") do
        find("div.block[role='button']").click
      end
    end

    it 'allows a logged-in user to like and unlike another user\'s catch with button state changes' do
      within "turbo-frame#like_button_#{other_catch.id}" do
        expect(page).to have_selector("a.likeButton", count: 1)
        expect(page).not_to have_css("a.liked")

        find("a.likeButton").click
        expect(page).to have_css("a.liked")
      end

      within "turbo-frame#like_button_#{other_catch.id}" do
        find("a.liked").click
        expect(page).not_to have_css("a.liked")
      end
    end
  end
end
