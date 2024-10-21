require 'rails_helper'

RSpec.describe 'コメント管理システム', type: :system, js: true do
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
    login_as(user, scope: :user)  # ログイン処理
  end

  context '自分の投稿に新しいコメントを作成する' do
    before do
      visit catches_path  # 自分の投稿の一覧ページに遷移
      within("div##{dom_id(catch)}") do
        find("button[data-modal-target='#{dom_id(catch, :modal)}']").click  # 詳細ページに遷移
      end
    end

    it 'ログインしているユーザーが新しいコメントを作成できる' do
      # コメントモーダルを開く
      find("button[data-modal-target='commentmodal_#{catch.id}']").click

      # コメントフォームに入力して送信
      within "turbo-frame##{dom_id(catch, :new_comment_form)}" do
        fill_in 'comment_content', with: '新しいコメントです'
        find("button[type='submit']").click
      end

      # コメントが表示されていることを確認
      expect(page).to have_content('新しいコメントです')
    end
  end

  context '他のユーザーの投稿に新しいコメントを作成する' do
    before do
      visit catches_path  # 他ユーザーの投稿の一覧ページに遷移
      within("div##{dom_id(other_catch)}") do
        find("button[data-modal-target='#{dom_id(other_catch, :modal)}']").click  # 他ユーザーの詳細ページに遷移
      end
    end

    it 'ログインしているユーザーが他のユーザーの投稿に新しいコメントを作成できる' do
      # コメントモーダルを開く
      find("button[data-modal-target='commentmodal_#{other_catch.id}']").click

      # コメントフォームに入力して送信
      within "turbo-frame##{dom_id(other_catch, :new_comment_form)}" do
        fill_in 'comment_content', with: '他のユーザーの投稿へのコメントです'
        find("button[type='submit']").click
      end

      # コメントが表示されていることを確認
      expect(page).to have_content('他のユーザーの投稿へのコメントです')
    end
  end
end
