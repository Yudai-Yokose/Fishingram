require 'rails_helper'

RSpec.describe 'ユーザーサインアップ', type: :system do
  it 'ユーザーがサインアップできること' do
    visit new_user_registration_path

    fill_in 'user_registration_username', with: 'testuser'
    fill_in 'user_registration_email', with: 'test@example.com'
    fill_in 'user_registration_password', with: 'password'
    fill_in 'user_registration_password_confirmation', with: 'password'

    click_button I18n.t("devise.registrations.new.sign_up")

    expect(page).to have_content(I18n.t("devise.registrations.signed_up"))
    expect(current_path).to eq(catches_path)
  end
end
