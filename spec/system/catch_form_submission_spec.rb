require 'rails_helper'

RSpec.describe 'Catch Form Submission', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000) # ここでウィンドウサイズを変更
  end

  context 'when user is not signed in' do
    it 'does not allow submission for guests' do
      visit root_path

      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within('#record-modal') do
        expect(page).to have_selector("turbo-frame#new_catch_form", visible: true)
      end

      within("turbo-frame#new_catch_form") do
        attach_file 'catch-dropzone-file', Rails.root.join('public', 'icon.png'), visible: false
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
        expect(find('input#catch-dropzone-file', visible: false).value).to eq("")
      end
    end
  end

  context 'when user is signed in' do
    before do
      login_as(user, scope: :user)
      visit catches_path
    end

    it 'allows submission and resets the form after submission' do
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within('#record-modal') do
        expect(page).to have_selector("turbo-frame#new_catch_form", visible: true)
      end

      within("turbo-frame#new_catch_form") do
        attach_file 'catch-dropzone-file', Rails.root.join('public', 'icon.png'), visible: false
        find('select[name="catch[tide]"]').select '大潮'
        find('select[name="catch[tide_level]"]').select '満潮前後'
        find('select[name="catch[range]"]').select 'トップ'
        find('select[name="catch[size]"]').select '20~30cm'
        fill_in 'memo', with: '今日は大潮でたくさん釣れました！'
        click_button I18n.t('activerecord.attributes.catch.new.submit')
      end

      within '#flash' do
        expect(page).to have_content(I18n.t("activerecord.attributes.catch.create.success"))
      end

      expect(page).to have_selector('turbo-frame#catch_index')

      new_catch = Catch.last

      frame_id = "catch_#{new_catch.id}"
      expect(page).to have_selector("turbo-frame##{frame_id}", wait: 5)

      within "turbo-frame##{frame_id}" do
        expect(page).to have_selector("img[src*='profile_image']", wait: 5)
        expect(page).to have_content(new_catch.user.username)
        formatted_time = new_catch.created_at.in_time_zone('Asia/Tokyo').strftime("%Y年%-m月%-d日 %-H時%-M分")
        expect(page).to have_content(formatted_time)
      end

      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within("turbo-frame#new_catch_form") do
        expect(find('textarea[name="catch[memo]"]').value).to eq('')
        expect(find('select[name="catch[tide]"]').value).to eq('')
        expect(find('select[name="catch[tide_level]"]').value).to eq('')
        expect(find('select[name="catch[range]"]').value).to eq('')
        expect(find('select[name="catch[size]"]').value).to eq('')
        expect(find('input#catch-dropzone-file', visible: false).value).to eq("")
      end
    end
  end
end
