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
    login_as(user, scope: :user)  # ログイン処理
  end

  context 'for own catch' do
    before do
      visit catches_path  # 自分の投稿の一覧ページに遷移
      within("turbo-frame#catch_#{catch.id}") do
        find("div.block[role='button']").click  # 詳細ページに遷移
      end
    end

    it 'allows a logged-in user to like and unlike their own catch with button state changes' do
      # いいねを付ける
      within "turbo-frame#like_button_#{catch.id}" do
        expect(page).to have_selector("button.likeButton", count: 1) # ボタンが表示されているか確認
        expect(page).not_to have_css("button.liked")  # 初期状態では `liked` クラスがないことを確認

        # いいねボタンをクリックして `liked` クラスが追加されることを確認
        find("button.likeButton").click
        expect(page).to have_css("button.liked")  # `liked` クラスが追加されたことを確認
      end

      # いいねを取り消す
      within "turbo-frame#like_button_#{catch.id}" do
        find("button.liked").click  # `liked` クラスが付いた状態でボタンをクリック
        expect(page).not_to have_css("button.liked")  # `liked` クラスが消えたことを確認
      end
    end
  end

  context 'for another user\'s catch' do
    before do
      visit catches_path  # 他ユーザーの投稿の一覧ページに遷移
      within("turbo-frame#catch_#{other_catch.id}") do
        find("div.block[role='button']").click  # 他のユーザーの投稿の詳細ページに遷移
      end
    end

    it 'allows a logged-in user to like and unlike another user\'s catch with button state changes' do
      within "turbo-frame#like_button_#{other_catch.id}" do
        expect(page).to have_selector("button.likeButton", count: 1) # ボタンが表示されているか確認
        expect(page).not_to have_css("button.liked")  # 初期状態では `liked` クラスがないことを確認

        # 他ユーザーの投稿にいいねを付ける
        find("button.likeButton").click
        expect(page).to have_css("button.liked")  # `liked` クラスが追加されたことを確認
      end

      # いいねを取り消す
      within "turbo-frame#like_button_#{other_catch.id}" do
        find("button.liked").click  # `liked` クラスが付いた状態でボタンをクリック
        expect(page).not_to have_css("button.liked")  # `liked` クラスが消えたことを確認
      end
    end
  end
end
