require 'rails_helper'

RSpec.describe 'User Sign In', type: :system do
  before do
    User.create!(email: 'test@gmail.com', password: 'aaaa', username: 'testuser')
  end

  it 'allows a user to sign in' do
    visit new_user_session_path

    fill_in 'user_session_email', with: 'test@gmail.com'
    fill_in 'user_session_password', with: 'aaaa'

    click_button 'ログイン'

    expect(page).to have_content('ログインしました。')
    expect(current_path).to eq(index_user_path)
  end
end
