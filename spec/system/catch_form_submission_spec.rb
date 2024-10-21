require 'rails_helper'

RSpec.describe '釣果フォームの送信', type: :system, js: true do
  include ActionView::RecordIdentifier
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)
  end

  context 'ユーザーがサインインしていない場合' do
    it 'ゲストが送信できないこと' do
      visit root_path

      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within('#record-modal') do
        expect(page).to have_selector("turbo-frame#new_catch_form", visible: true)
      end

      within("turbo-frame#new_catch_form") do
        attach_file dom_id(Catch.new(user: user), :dropzone_file), Rails.root.join('public', 'icon.png'), visible: false
        find('select[name="catch[tide]"]').select '大潮'
        find('select[name="catch[tide_level]"]').select '満潮前後'
        find('select[name="catch[range]"]').select 'トップ'
        find('select[name="catch[size]"]').select '20~30cm'
        fill_in 'memo', with: '今日は大潮でたくさん釣れました！'
        click_button I18n.t('activerecord.attributes.catch.new.submit')
      end

      expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))

      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within("turbo-frame#new_catch_form") do
        expect(find('textarea[name="catch[memo]"]').value).to eq('')
        expect(find('select[name="catch[tide]"]').value).to eq('')
        expect(find('select[name="catch[tide_level]"]').value).to eq('')
        expect(find('select[name="catch[range]"]').value).to eq('')
        expect(find('select[name="catch[size]"]').value).to eq('')
        expect(find("input##{dom_id(Catch.new(user: user), :dropzone_file)}", visible: false).value).to eq("")
      end
    end
  end

  context 'ユーザーがサインインしている場合（全ての釣果）' do
    before do
      login_as(user, scope: :user)
    end

    it '送信を許可し、送信後にフォームをリセットすること' do
      visit catches_path
      # モーダルを開く
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      # フォームが正しく表示されていることを確認
      within('#record-modal') do
        expect(page).to have_selector("turbo-frame#new_catch_form", visible: true)
      end

      # フォームに入力
      within("turbo-frame#new_catch_form") do
        attach_file dom_id(Catch.new(user: user), :dropzone_file), Rails.root.join('public', 'icon.png'), visible: false
        find('select[name="catch[tide]"]').select '大潮'
        find('select[name="catch[tide_level]"]').select '満潮前後'
        find('select[name="catch[range]"]').select 'トップ'
        find('select[name="catch[size]"]').select '20~30cm'
        fill_in 'memo', with: '今日は大潮でたくさん釣れました！'
        click_button I18n.t('activerecord.attributes.catch.new.submit')
      end

      # フラッシュメッセージの確認
      within '#flash' do
        expect(page).to have_content(I18n.t("activerecord.attributes.catch.create.success"))
      end

      # 新しく追加された釣果が投稿一覧にprependされているか確認
      new_catch = Catch.last
      expect(page).to have_selector("div##{dom_id(new_catch)}")

      within "div##{dom_id(new_catch)}" do
        expect(page).to have_selector("img[src*='profile_image']", wait: 5)
        expect(page).to have_content(new_catch.user.username)
        formatted_time = new_catch.created_at.in_time_zone('Asia/Tokyo').strftime("%Y年%-m月%-d日 %-H時%-M分")
        expect(page).to have_content(formatted_time)
      end

      # モーダルを再度開く
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      # フォームがリセットされていることを確認
      within("turbo-frame#new_catch_form") do
        expect(find('textarea[name="catch[memo]"]').value).to eq('')
        expect(find('select[name="catch[tide]"]').value).to eq('')
        expect(find('select[name="catch[tide_level]"]').value).to eq('')
        expect(find('select[name="catch[range]"]').value).to eq('')
        expect(find('select[name="catch[size]"]').value).to eq('')
        expect(find("input##{dom_id(Catch.new(user: user), :dropzone_file)}", visible: false).value).to eq("")
      end
    end
  end

  context 'ユーザーがサインインしている場合（自分の釣果）' do
    before do
      login_as(user, scope: :user)
    end

    it '送信を許可し、送信後にフォームをリセットすること' do
      visit index_user_path
      # モーダルを開く
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      # フォームが正しく表示されていることを確認
      within('#record-modal') do
        expect(page).to have_selector("turbo-frame#new_catch_form", visible: true)
      end

      # フォームに入力
      within("turbo-frame#new_catch_form") do
        attach_file dom_id(Catch.new(user: user), :dropzone_file), Rails.root.join('public', 'icon.png'), visible: false
        find('select[name="catch[tide]"]').select '大潮'
        find('select[name="catch[tide_level]"]').select '満潮前後'
        find('select[name="catch[range]"]').select 'トップ'
        find('select[name="catch[size]"]').select '20~30cm'
        fill_in 'memo', with: '今日は大潮でたくさん釣れました！'
        click_button I18n.t('activerecord.attributes.catch.new.submit')
      end

      # フラッシュメッセージの確認
      within '#flash' do
        expect(page).to have_content(I18n.t("activerecord.attributes.catch.create.success"))
      end

      # 新しく追加された釣果が投稿一覧にprependされているか確認
      new_catch = Catch.last
      expect(page).to have_selector("div##{dom_id(new_catch)}")

      within "div##{dom_id(new_catch)}" do
        expect(page).to have_selector("img[src*='profile_image']", wait: 5)
        expect(page).to have_content(new_catch.user.username)
        formatted_time = new_catch.created_at.in_time_zone('Asia/Tokyo').strftime("%Y年%-m月%-d日 %-H時%-M分")
        expect(page).to have_content(formatted_time)
      end

      # モーダルを再度開く
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      # フォームがリセットされていることを確認
      within("turbo-frame#new_catch_form") do
        expect(find('textarea[name="catch[memo]"]').value).to eq('')
        expect(find('select[name="catch[tide]"]').value).to eq('')
        expect(find('select[name="catch[tide_level]"]').value).to eq('')
        expect(find('select[name="catch[range]"]').value).to eq('')
        expect(find('select[name="catch[size]"]').value).to eq('')
        expect(find("input##{dom_id(Catch.new(user: user), :dropzone_file)}", visible: false).value).to eq("")
      end
    end
  end
end
