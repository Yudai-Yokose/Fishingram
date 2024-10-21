require 'rails_helper'

RSpec.describe '釣果投稿管理', type: :system, js: true do
  include ActionView::RecordIdentifier
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }
  let!(:catch) { Catch.create!(user: user, tide: '大潮', tide_level: '満潮前後', range: 'トップ', size: '30~40cm', memo: '良い釣果！', images: [ fixture_file_upload(Rails.root.join('public', 'icon.png')) ]) }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)  # テスト用ブラウザのサイズを設定
  end

  context '釣果を閲覧する場合' do
    before do
      visit catches_path  # 投稿一覧ページに遷移
      within("div##{dom_id(catch)}") do
      find("button[data-modal-target='#{dom_id(catch, :modal)}']").click  # 釣果詳細を表示するボタンをクリック
      end
    end

    it 'ユーザーが釣果の詳細を閲覧できること' do
      within("div##{dom_id(catch, :details)}") do
        expect(page).to have_content(catch.tide)  # 潮の状態を確認
        expect(page).to have_content(catch.tide_level)  # 潮のレベルを確認
        expect(page).to have_content(catch.range)  # 範囲を確認
        expect(page).to have_content(catch.size)  # サイズを確認
        expect(page).to have_content(catch.memo)  # メモを確認
      end

      within("div##{dom_id(catch, :images)}") do
        expect(page).to have_selector("img[src*='icon.png']")  # 画像が表示されているか確認
      end
    end
  end

  context 'ユーザーが釣果の所有者である場合' do
    before do
      login_as(user, scope: :user)  # ユーザーとしてログイン
      visit catches_path  # 投稿一覧ページに遷移
      within("div##{dom_id(catch)}") do
        find("button[data-modal-target='#{dom_id(catch, :modal)}']").click  # 釣果詳細を表示するボタンをクリック
      end
    end

    it '所有者がすべてのフィールドを編集し、既存の画像を削除して新しい画像を追加できること' do
      # 編集ボタンが表示されていることを確認
      expect(page).to have_selector("button[data-modal-target='catcheditmodal_#{catch.id}']")

      # 編集モーダルを開く
      find("button[data-modal-target='catcheditmodal_#{catch.id}']").click
      expect(page).to have_selector("turbo-frame##{dom_id(catch, :edit)}", visible: true)

      within "turbo-frame##{dom_id(catch, :edit)}" do
        # フィールドを新しい値に変更
        fill_in 'catch[memo]', with: '更新されたメモ'
        select '小潮', from: 'catch[tide]'
        select '干潮前後', from: 'catch[tide_level]'
        select '中層', from: 'catch[range]'
        select '50~60cm', from: 'catch[size]'

        # 既存の画像を削除する
        within("turbo-frame##{dom_id(catch, :image)}") do
          find("a[data-turbo-method='delete']").click
        end

        # 新しい画像を添付
        attach_file(dom_id(catch, :dropzone_file), Rails.root.join('public', 'icon_white.png'), visible: false)

        # フォームを送信
        click_button I18n.t('activerecord.attributes.catch.edit.submit')
      end

      # 編集後も詳細画面が表示され続けていることを確認
      within("div##{dom_id(catch, :details)}") do
        # 更新された内容が正しく表示されていることを確認
        expect(page).to have_content('更新されたメモ')
        expect(page).to have_content('小潮')
        expect(page).to have_content('干潮前後')
        expect(page).to have_content('中層')
        expect(page).to have_content('50~60cm')
      end

      # 新しい画像が正しく表示されているか確認
      within("div##{dom_id(catch, :images)}") do
        expect(page).to have_selector("img[src*='icon_white.png']", wait: 5)
      end

      # 削除リンクが存在することを確認
      expect(page).to have_selector("button[data-turbo-method='delete']")

      # 削除を実行して確認
      accept_confirm do
        find("button[data-turbo-method='delete']").click
      end
      expect(page).to have_content(I18n.t("activerecord.attributes.catch.destroy.success"))
    end
  end

  context 'ユーザーが釣果の所有者でない場合' do
    before do
      login_as(other_user, scope: :user)  # 他のユーザーとしてログイン
      visit catches_path  # 投稿一覧ページに遷移
      within("div##{dom_id(catch)}") do
        find("button[data-modal-target='#{dom_id(catch, :modal)}']").click  # 釣果詳細を表示するボタンをクリック
      end
    end

    it '他のユーザーが釣果を編集または削除できないこと' do
      expect(page).not_to have_selector("button[data-modal-target='catcheditmodal_#{catch.id}']")  # 編集ボタンがないことを確認
      expect(page).not_to have_selector("button[data-turbo-method='delete']")  # 削除リンクがないことを確認
    end
  end
end
