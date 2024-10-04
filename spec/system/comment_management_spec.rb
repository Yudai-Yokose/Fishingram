require 'rails_helper'

RSpec.describe 'Comment System', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }

  # 自分の投稿とコメント
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！') }
  let!(:comment) { Comment.create!(content: 'This is a test comment', user: user, catch: catch) }

  # 他ユーザーの投稿とコメント
  let!(:other_catch) { Catch.create!(user: other_user, tide: '小潮', tide_level: '干潮前後', range: 'ボトム', size: '50~60cm', memo: '素晴らしい釣果！') }
  let!(:other_comment) { Comment.create!(content: 'This is a comment on another user\'s post', user: other_user, catch: other_catch) }

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

    it 'displays the comment on the catch details page' do
      within "turbo-frame#catch_#{catch.id}_comments" do
        expect(page).to have_content('This is a test comment')
      end
    end

    it 'allows a logged-in user to edit a comment' do
      # スクロールして編集ボタンが表示されるようにする
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']")

      # ドロップダウンメニューを開く
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']").click

      # 編集モーダルを開く
      find("button[data-modal-target='editcommentmodal_#{comment.id}']").click

      # コメントを編集して送信
      within "turbo-frame#edit_comment_#{comment.id}_form" do
        fill_in 'comment_content', with: 'This is an updated comment'
        click_button I18n.t('activerecord.attributes.comment.edit.submit')
      end

      # 編集後のコメントが表示されていることを確認
      within "turbo-frame#catch_#{catch.id}_comments" do
        expect(page).to have_content('This is an updated comment')
        expect(page).not_to have_content('This is a test comment')
      end
    end

    it 'allows a logged-in user to delete a comment' do
      # スクロールして削除ボタンが表示されるようにする
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']")

      # ドロップダウンメニューを開く
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']").click

      # 削除ボタンをクリック
      find("form[action='#{catch_comment_path(catch, comment)}'] button").click

      # コメントが削除されたことを確認
      within "turbo-frame#catch_#{catch.id}_comments" do
        expect(page).not_to have_content('This is a test comment')
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

    it 'displays the comment on another user\'s post' do
      within "turbo-frame#catch_#{other_catch.id}_comments" do
        expect(page).to have_content('This is a comment on another user\'s post')
      end
    end

    it 'does not display edit and delete buttons for comments on another user\'s post' do
      within "turbo-frame#catch_#{other_catch.id}_comments" do
        # 編集・削除ボタンが表示されていないことを確認
        expect(page).not_to have_selector("button[data-modal-target='editcommentmodal_#{other_comment.id}']")
        expect(page).not_to have_selector("form[action='#{catch_comment_path(other_catch, other_comment)}'] button")
      end
    end
  end
end
