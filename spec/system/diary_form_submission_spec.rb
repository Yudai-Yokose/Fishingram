require 'rails_helper'

RSpec.describe 'Diary Form Submission', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000) # ここでウィンドウサイズを変更
  end

  context 'when user is not signed in' do
    it 'does not allow submission for guests' do
      visit root_path

      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      find('button[data-index="1"]').click
      expect(page).to have_selector("turbo-frame#new_diary_form", visible: true)

      within("turbo-frame#new_diary_form") do
        attach_file 'diary-dropzone-file', Rails.root.join('public', 'icon.png'), visible: false
        fill_in 'default-datepicker', with: '2023-10-01'
        find('label[for="diary-dropzone-file"]').click
        find('select[name="diary[weather]"]').select '晴れ'
        find('select[name="diary[time_of_day]"]').select '朝まづめ'
        find('select[name="diary[temperature]"]').select '20~30℃'
        find('select[name="diary[catch_count]"]').select '5匹'
        fill_in 'content', with: '今日は良い天気でした！'
        click_button I18n.t('activerecord.attributes.diary.new.submit')
      end

      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))

      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within("turbo-frame#new_diary_form") do
        expect(find('textarea[name="diary[content]"]').value).to eq('')
        expect(find('select[name="diary[weather]"]').value).to eq('')
        expect(find('select[name="diary[time_of_day]"]').value).to eq('')
        expect(find('select[name="diary[temperature]"]').value).to eq('')
        expect(find('select[name="diary[catch_count]"]').value).to eq('')
        expect(find('input#diary-dropzone-file', visible: false).value).to eq("")
      end
    end
  end

  context 'when user is signed in' do
    before do
      login_as(user, scope: :user)
      visit diaries_path
    end

    it 'allows submission for signed-in users and resets the form after submission' do
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      find('button[data-index="1"]').click
      expect(page).to have_selector("turbo-frame#new_diary_form", visible: true)

      within("turbo-frame#new_diary_form") do
        attach_file 'diary-dropzone-file', Rails.root.join('public', 'icon.png'), visible: false
        fill_in 'default-datepicker', with: '2023-10-01'
        find('label[for="diary-dropzone-file"]').click
        find('select[name="diary[weather]"]').select '晴れ'
        find('select[name="diary[time_of_day]"]').select '朝まづめ'
        find('select[name="diary[temperature]"]').select '20~30℃'
        find('select[name="diary[catch_count]"]').select '5匹'
        fill_in 'content', with: '今日は良い天気でした！'
        click_button I18n.t('activerecord.attributes.diary.new.submit')
      end

      within '#flash' do
        expect(page).to have_content(I18n.t("activerecord.attributes.diary.create.success"))
      end

      expect(page).to have_selector('turbo-frame#diary_index')

      new_diary = Diary.last
      frame_id = "diary_#{new_diary.id}"
      expect(page).to have_selector("turbo-frame##{frame_id}", wait: 5)

      within "turbo-frame##{frame_id}" do
        expect(page).to have_selector("img[src*='profile_image']", wait: 5)
        expect(page).to have_content(new_diary.user.username)
        formatted_time = I18n.l(new_diary.diary_date, format: :long)
        expect(page).to have_content(formatted_time)
      end

      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within("turbo-frame#new_diary_form") do
        expect(find('textarea[name="diary[content]"]').value).to eq('')
        expect(find('select[name="diary[weather]"]').value).to eq('')
        expect(find('select[name="diary[time_of_day]"]').value).to eq('')
        expect(find('select[name="diary[temperature]"]').value).to eq('')
        expect(find('select[name="diary[catch_count]"]').value).to eq('')
        expect(find('input#diary-dropzone-file', visible: false).value).to eq("")
      end
    end
  end
end
