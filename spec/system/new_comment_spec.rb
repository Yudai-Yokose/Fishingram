require 'rails_helper'

RSpec.describe 'Comment Management System', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }

  # 自分の投稿とコメント
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！') }

  # 他ユーザーの投稿
  let!(:other_catch) { Catch.create!(user: other_user, tide: '小潮', tide_level: '干潮前後', range: 'ボトム', size: '50~60cm', memo: '素晴らしい釣果！') }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000) # ここでウィンドウサイズを変更
  end

  before do
    login_as(user, scope: :user)  # ログイン処理
  end

  context 'Creating a new comment on own catch' do
    before do
      visit catches_path  # 自分の投稿の一覧ページに遷移
      within("turbo-frame#catch_#{catch.id}") do
        find("div.block[role='button']").click  # 詳細ページに遷移
      end
    end

    it 'allows a logged-in user to create a new comment' do
      # コメントモーダルを開く
      find("button[data-modal-target='commentmodal_#{catch.id}']").click

      # コメントフォームに入力して送信
      within "turbo-frame#new_comment_#{catch.id}_form" do
        fill_in 'comment[content]', with: 'This is a new comment'
        click_button I18n.t('activerecord.attributes.comment.new.submit')
      end

      # コメントが表示されていることを確認
      within "turbo-frame#catch_#{catch.id}_comments" do
        expect(page).to have_content('This is a new comment')
      end
    end
  end

  context 'Creating a new comment on another user\'s catch' do
    before do
      visit catches_path  # 他ユーザーの投稿の一覧ページに遷移
      within("turbo-frame#catch_#{other_catch.id}") do
        find("div.block[role='button']").click  # 他ユーザーの詳細ページに遷移
      end
    end

    it 'allows a logged-in user to create a new comment on another user\'s post' do
      # コメントモーダルを開く
      find("button[data-modal-target='commentmodal_#{other_catch.id}']").click

      # コメントフォームに入力して送信
      within "turbo-frame#new_comment_#{other_catch.id}_form" do
        fill_in 'comment[content]', with: 'This is a comment on another user\'s post'
        click_button I18n.t('activerecord.attributes.comment.new.submit')
      end

      # コメントが表示されていることを確認
      within "turbo-frame#catch_#{other_catch.id}_comments" do
        expect(page).to have_content('This is a comment on another user\'s post')
      end
    end
  end
end
