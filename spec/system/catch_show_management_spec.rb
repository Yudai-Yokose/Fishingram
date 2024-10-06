require 'rails_helper'
include ActionView::RecordIdentifier

RSpec.describe 'Catch Post Management', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！', images: [ fixture_file_upload(Rails.root.join('public', 'icon.png')) ]) }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)
  end

  context 'when viewing a catch post' do
    before do
      visit catches_path  # 投稿一覧ページに遷移
      within("turbo-frame#catch_#{catch.id}") do
        find("div.block[role='button']").click
      end
    end

    it 'allows a user to view the catch details' do
      within("turbo-frame#catch_show_#{catch.id}_details") do
        expect(page).to have_content(catch.tide)
        expect(page).to have_content(catch.tide_level)
        expect(page).to have_content(catch.range)
        expect(page).to have_content(catch.size)
        expect(page).to have_content(catch.memo)
      end

      within("turbo-frame#catch_show_#{catch.id}_images") do
        expect(page).to have_selector("img[src*='icon.png']")
      end
    end
  end

  context 'when the user is the owner of the catch' do
    before do
      login_as(user, scope: :user)
      visit catches_path  # 投稿一覧ページに遷移
      within("turbo-frame#catch_#{catch.id}") do
        find("div.block[role='button']").click
      end
    end

    it 'allows the owner to edit all fields, delete the existing image, and replace it with a new one' do
      # 編集ボタンが表示されていることを確認
      expect(page).to have_selector("button[data-modal-target='catcheditmodal_#{catch.id}']")

      # 編集モーダルを開く
      find("button[data-modal-target='catcheditmodal_#{catch.id}']").click
      expect(page).to have_selector("turbo-frame#edit_catch_#{catch.id}_form", visible: true)

      within "turbo-frame#edit_catch_#{catch.id}_form" do
        # フィールドを新しい値に変更
        fill_in 'catch[memo]', with: '更新されたメモ'
        select '小潮', from: 'catch[tide]'
        select '干潮前後', from: 'catch[tide_level]'
        select '中層', from: 'catch[range]'
        select '50~60cm', from: 'catch[size]'

        # 既存の画像を削除する
        within("turbo-frame##{dom_id(catch.images.first)}") do
          find("a[data-turbo-method='delete']").click
        end

        # 新しい画像を添付
        attach_file('catch-dropzone-file', Rails.root.join('public', 'icon_white.png'), visible: false)

        # フォームを送信
        click_button I18n.t('activerecord.attributes.catch.edit.submit')
      end

      # 編集後も詳細画面が表示され続けていることを確認
      within("turbo-frame#catch_show_#{catch.id}_details") do
        # 更新された内容が正しく表示されていることを確認
        expect(page).to have_content('更新されたメモ')
        expect(page).to have_content('小潮')
        expect(page).to have_content('干潮前後')
        expect(page).to have_content('中層')
        expect(page).to have_content('50~60cm')
      end

      # 新しい画像が正しく表示されているか確認
      within("turbo-frame#catch_show_#{catch.id}_images") do
        expect(page).to have_selector("img[src*='icon_white.png']", wait: 5)
      end

      # 削除リンクが存在することを確認
      expect(page).to have_selector("a[data-turbo-method='delete']")

      # 削除を実行して確認
      accept_confirm do
        find("a[data-turbo-method='delete']").click
      end
      expect(page).to have_content(I18n.t("activerecord.attributes.catch.destroy.success"))
    end
  end

  context 'when the user is not the owner of the catch' do
    before do
      login_as(other_user, scope: :user)
      visit catches_path  # 投稿一覧ページに遷移
      within("turbo-frame#catch_#{catch.id}") do
        find("div.block[role='button']").click
      end
    end

    it 'does not allow other users to edit or delete the catch' do
      expect(page).not_to have_selector("button[data-modal-target='catcheditmodal_#{catch.id}']")
      expect(page).not_to have_selector("a[data-turbo-method='delete']")
    end
  end
end
