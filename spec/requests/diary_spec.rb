require 'rails_helper'

RSpec.describe "Diaries", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password', username: 'otheruser') }
  let!(:diary) { Diary.create!(user: user, diary_date: Date.today, content: '今日は良い釣り日和でした', weather: '晴れ', catch_count: '1匹', time_of_day: '朝まづめ', temperature: '20~30℃', images: [ fixture_file_upload(Rails.root.join('public', 'icon.png')) ]) }

  describe "GET /diaries/:id" do
    context "when logged in as the correct user" do
      before { sign_in user }

      it "returns a successful response and displays the correct diary content" do
        get diary_path(diary)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('今日は良い釣り日和でした')
        expect(response.body).to include('晴れ')
        expect(response.body).to include('1匹')
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "redirects to the diaries index with a correct user notice" do
        get diary_path(diary)
        expect(response).to redirect_to(diaries_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("activerecord.attributes.diary.correct_user"))
      end
    end
  end

  describe "GET /diaries/:id/edit" do
    context "when logged in as the correct user" do
      before { sign_in user }

      it "returns a successful response and displays the edit form" do
        get edit_diary_path(diary)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('今日は良い釣り日和でした')
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "redirects to the diaries index with a correct user notice" do
        get edit_diary_path(diary)
        expect(response).to redirect_to(diaries_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("activerecord.attributes.diary.correct_user"))
      end
    end
  end

  describe "PATCH /diaries/:id" do
    context "when logged in as the correct user" do
      before { sign_in user }

      it "updates the diary and redirects to the diary show page" do
        patch diary_path(diary), params: { diary: { content: "更新された内容" } }
        expect(response).to redirect_to(diary_path(diary))
        follow_redirect!
        expect(response.body).to include("更新された内容")
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "does not update the diary and redirects to the diaries index" do
        patch diary_path(diary), params: { diary: { content: "更新された内容" } }
        expect(response).to redirect_to(diaries_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("activerecord.attributes.diary.correct_user"))
      end
    end
  end

  describe "DELETE /diaries/:id" do
    context "when logged in as the correct user" do
      before { sign_in user }

      it "deletes the diary and redirects to the diaries index" do
        expect {
          delete diary_path(diary)
        }.to change(Diary, :count).by(-1)
        expect(response).to redirect_to(diaries_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("activerecord.attributes.diary.destroy.success"))
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "does not delete the diary and redirects to the diaries index" do
        expect {
          delete diary_path(diary)
        }.not_to change(Diary, :count)
        expect(response).to redirect_to(diaries_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("activerecord.attributes.diary.correct_user"))
      end
    end
  end
end
