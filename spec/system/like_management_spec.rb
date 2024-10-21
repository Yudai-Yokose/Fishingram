require 'rails_helper'

RSpec.describe 'いいねシステム', type: :system, js: true do
  include ActionView::RecordIdentifier
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

  context '自分の投稿について' do
    before do
      visit catches_path
      within("div##{dom_id(catch)}") do
        find("button[data-modal-target='#{dom_id(catch, :modal)}']").click
      end
    end

    it 'ログインしているユーザーが自分の投稿にいいねを付けたり外したりできること' do
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

  context '他のユーザーの投稿について' do
    before do
      visit catches_path
      within("div##{dom_id(other_catch)}") do
        find("button[data-modal-target='#{dom_id(other_catch, :modal)}']").click
      end
    end

    it 'ログインしているユーザーが他のユーザーの投稿にいいねを付けたり外したりできること' do
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
