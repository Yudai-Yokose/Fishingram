require 'rails_helper'

RSpec.describe '日記フォームの送信', type: :system, js: true do
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

      find('button[data-tabs-target="#diary"]').click
      expect(page).to have_selector("turbo-frame#new_diary_form", visible: true)

      within("turbo-frame#new_diary_form") do
        attach_file dom_id(Diary.new(user: user), :dropzone_file), Rails.root.join('public', 'icon.png'), visible: false
        fill_in 'default-datepicker', with: '2024-10-01'
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
        expect(find("input##{dom_id(Diary.new(user: user), :dropzone_file)}", visible: false).value).to eq("")
      end
    end
  end

  context 'ユーザーがサインインしている場合' do
    before do
      login_as(user, scope: :user)
    end

    it '送信を許可し、送信後にフォームをリセットすること' do
      visit diaries_path
      # モーダルを開く
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      # フォームが正しく表示されていることを確認
      find('button[data-tabs-target="#diary"]').click
      expect(page).to have_selector("turbo-frame#new_diary_form", visible: true)

      # フォームに入力
      within("turbo-frame#new_diary_form") do
        attach_file dom_id(Diary.new(user: user), :dropzone_file), Rails.root.join('public', 'icon.png'), visible: false
        fill_in 'default-datepicker', with: '2024-10-01'
        find('select[name="diary[weather]"]').select '晴れ'
        find('select[name="diary[time_of_day]"]').select '朝まづめ'
        find('select[name="diary[temperature]"]').select '20~30℃'
        find('select[name="diary[catch_count]"]').select '5匹'
        fill_in 'content', with: '今日は良い天気でした！'
        click_button I18n.t('activerecord.attributes.diary.new.submit')
      end

      # フラッシュメッセージの確認
      within '#flash' do
        expect(page).to have_content(I18n.t("activerecord.attributes.diary.create.success"))
      end

      # 新しく追加された日記が投稿一覧にprependされているか確認
      new_diary = Diary.last
      expect(page).to have_selector("div##{dom_id(new_diary)}")

      within "div##{dom_id(new_diary)}" do
        expect(page).to have_selector("img[src*='profile_image']", wait: 5)
        expect(page).to have_content(new_diary.user.username)
        formatted_time = I18n.l(new_diary.diary_date, format: :long)
        expect(page).to have_content(formatted_time)
      end

      # モーダルを再度開く
      find("button[data-modal-target='record-modal']").click
      expect(page).to have_selector('#record-modal', visible: true)

      within("turbo-frame#new_diary_form") do
        expect(find('textarea[name="diary[content]"]').value).to eq('')
        expect(find('select[name="diary[weather]"]').value).to eq('')
        expect(find('select[name="diary[time_of_day]"]').value).to eq('')
        expect(find('select[name="diary[temperature]"]').value).to eq('')
        expect(find('select[name="diary[catch_count]"]').value).to eq('')
        expect(find("input##{dom_id(Diary.new(user: user), :dropzone_file)}", visible: false).value).to eq("")
      end
    end
  end
end
