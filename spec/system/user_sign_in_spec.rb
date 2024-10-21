require 'rails_helper'

RSpec.describe 'ユーザーサインイン', type: :system do
  before do
    User.create!(email: 'test@gmail.com', password: 'aaaa', username: 'testuser')
  end

  it 'ユーザーがサインインできること' do
    visit new_user_session_path

    fill_in 'user_session_email', with: 'test@gmail.com'
    fill_in 'user_session_password', with: 'aaaa'

    click_button I18n.t("devise.sessions.form.sign_in")

    expect(page).to have_content(I18n.t("devise.sessions.success"))
    expect(current_path).to eq(index_user_path)
  end
end
