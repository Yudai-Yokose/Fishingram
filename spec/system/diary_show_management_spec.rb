require 'rails_helper'

RSpec.describe '日記投稿管理', type: :system, js: true do
  include ActionView::RecordIdentifier
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }
  let!(:diary) { Diary.create!(user: user, diary_date: Date.today, content: '今日は良い釣り日和でした', weather: '晴れ', catch_count: '1匹', time_of_day: '朝まづめ', temperature: '20~30℃', images: [ fixture_file_upload(Rails.root.join('public', 'icon.png')) ]) }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)
  end

  context 'ユーザーが日記の所有者である場合' do
    before do
      login_as(user, scope: :user)
      visit diaries_path  # 投稿一覧ページに遷移
      within("div##{dom_id(diary)}") do
        find("button[data-modal-target='#{dom_id(diary, :modal)}']").click
      end
    end

    it 'ユーザーが日記の詳細を表示できる' do
      within("div##{dom_id(diary, :details)}") do
        expect(page).to have_content(diary.content)
        expect(page).to have_content('晴れ')
        expect(page).to have_content('1匹')
        expect(page).to have_content('朝まづめ')
        expect(page).to have_content('20~30℃')
      end

      within("div##{dom_id(diary, :images)}") do
        expect(page).to have_selector("img[src*='icon.png']")
      end
    end

    it '所有者がすべてのフィールドを編集し、既存の画像を削除して新しいものに置き換えることができる' do
      # 編集ボタンが表示されていることを確認
      expect(page).to have_selector("button[data-modal-target='diaryeditmodal_#{diary.id}']")

      # 編集モーダルを開く
      find("button[data-modal-target='diaryeditmodal_#{diary.id}']").click
      expect(page).to have_selector("turbo-frame##{dom_id(diary, :edit)}", visible: true)

      within "turbo-frame##{dom_id(diary, :edit)}" do
        # フィールドを新しい値に変更
        fill_in 'diary[content]', with: '更新された内容'
        select '雨', from: 'diary[weather]'
        select '爆釣', from: 'diary[catch_count]'
        select 'Night', from: 'diary[time_of_day]'
        select '真夏日', from: 'diary[temperature]'

        # 既存の画像を削除する
        within("turbo-frame##{dom_id(diary, :image)}") do
          find("a[data-turbo-method='delete']").click
        end

        # 新しい画像を添付
        attach_file(dom_id(diary, :dropzone_file), Rails.root.join('public', 'icon_white.png'), visible: false)

        # フォームを送信
        click_button I18n.t('activerecord.attributes.diary.edit.submit')
      end

      # 編集後も詳細画面が表示され続けていることを確認
      within("div##{dom_id(diary, :details)}") do
        # 更新された内容が正しく表示されていることを確認
        expect(page).to have_content('更新された内容')
        expect(page).to have_content('雨')
        expect(page).to have_content('爆釣')
        expect(page).to have_content('Night')
        expect(page).to have_content('真夏日')
      end

      # 新しい画像が正しく表示されているか確認
      within("div##{dom_id(diary, :images)}") do
        expect(page).to have_selector("img[src*='icon_white.png']", wait: 5)
      end

      # 削除リンクが存在することを確認
      expect(page).to have_selector("button[data-turbo-method='delete']")

      # 削除を実行して確認
      accept_confirm do
        find("button[data-turbo-method='delete']").click
      end
      expect(page).to have_content(I18n.t("activerecord.attributes.diary.destroy.success"))
    end
  end

  context 'ユーザーが日記の所有者でない場合' do
    before do
      login_as(other_user, scope: :user)
    end

    it '他のユーザーが日記を表示できない' do
      visit diary_path(diary)

      expect(page).to have_content(I18n.t('activerecord.attributes.catch.correct_user'))
    end
  end
end
