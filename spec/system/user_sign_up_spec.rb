require 'rails_helper'

RSpec.describe 'User Sign Up', type: :system do
  it 'allows a user to sign up' do
    visit new_user_registration_path

    fill_in 'user_registration_username', with: 'testuser'
    fill_in 'user_registration_email', with: 'test@example.com'
    fill_in 'user_registration_password', with: 'password'
    fill_in 'user_registration_password_confirmation', with: 'password'

    click_button 'アカウント登録'

    expect(page).to have_content('アカウント登録が完了しました。')
    expect(current_path).to eq(catches_path)
  end
end
