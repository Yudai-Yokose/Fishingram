require 'rails_helper'

RSpec.describe 'コメントシステム', type: :system, js: true do
  include ActionView::RecordIdentifier
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }

  # 自分の投稿とコメント
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！', images: [ fixture_file_upload(Rails.root.join('public', 'icon.png')) ]) }
  let!(:comment) { Comment.create!(content: 'これはテストコメントです', user: user, catch: catch) }

  # 他ユーザーの投稿とコメント
  let!(:other_catch) { Catch.create!(user: other_user, tide: '小潮', tide_level: '干潮前後', range: 'ボトム', size: '50~60cm', memo: '素晴らしい釣果！', images: [ fixture_file_upload(Rails.root.join('public', 'icon.png')) ]) }
  let!(:other_comment) { Comment.create!(content: 'これは他のユーザーの投稿へのコメントです', user: other_user, catch: other_catch) }

  before do
    page.driver.browser.manage.window.resize_to(475, 1500)
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

    it '投稿の詳細ページにコメントが表示される' do
      find("button[data-modal-target='commentmodal_#{catch.id}']").click
      expect(page).to have_content('これはテストコメントです')
    end

    it 'ログインしているユーザーがコメントを編集できる' do
      find("button[data-modal-target='commentmodal_#{catch.id}']").click
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']")
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']").click
      find("button[data-modal-target='#{dom_id(comment, :modal)}']").click

      within "turbo-frame##{dom_id(comment, :edit)}" do
        fill_in 'comment_content', with: 'これは更新されたコメントです'
        find("button[type='submit']").click
      end

      # 編集後のコメントが詳細ページに表示されることを確認
      expect(page).to have_content('これは更新されたコメントです')
      expect(page).not_to have_content('これはテストコメントです')
    end

    it 'ログインしているユーザーがコメントを削除できる' do
      find("button[data-modal-target='commentmodal_#{catch.id}']").click
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']")
      find("button[data-dropdown-toggle='dropdownDots_#{comment.id}']").click
      find("form[action='#{catch_comment_path(catch, comment)}'] button").click

      expect(page).not_to have_content('これはテストコメントです')
    end
  end

  context '他のユーザーの投稿について' do
    before do
      visit catches_path
      within("div##{dom_id(other_catch)}") do
        find("button[data-modal-target='#{dom_id(other_catch, :modal)}']").click
      end
    end

    it '他のユーザーの投稿にコメントが表示される' do
      find("button[data-modal-target='commentmodal_#{other_catch.id}']").click
      expect(page).to have_content('これは他のユーザーの投稿へのコメントです')
    end

    it '他のユーザーの投稿に対するコメントには編集・削除ボタンが表示されない' do
      find("button[data-modal-target='commentmodal_#{other_catch.id}']").click
      expect(page).not_to have_selector("button[data-modal-target='editcommentmodal_#{other_comment.id}']")
      expect(page).not_to have_selector("form[action='#{catch_comment_path(other_catch, other_comment)}'] button")
    end
  end
end
