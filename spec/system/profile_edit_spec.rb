require 'rails_helper'

RSpec.describe 'User Profile Edit', type: :system, js: true do
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)
  end

  before do
    login_as(user, scope: :user)
  end

  it 'allows user to open and close the profile edit modal' do
    visit edit_user_registration_path

    expect(page).to have_content('My Page')
    find('button[data-modal-target="profilemodal"]').click
    expect(page).to have_selector('#profilemodal', visible: true)
    expect(page).to have_field('user[username]', with: user.username)
    expect(page).to have_field('user[email]', with: user.email)
    find('button[data-modal-hide="profilemodal"]').click
    expect(page).not_to have_selector('#profilemodal', visible: true)
  end

  it 'allows user to edit profile information with new image' do
    visit edit_user_registration_path

    expect(page).to have_content('My Page')
    find('button[data-modal-target="profilemodal"]').click
    attach_file 'profile-dropzone-file', Rails.root.join('public', 'icon_white.png'), visible: false
    fill_in 'user[username]', with: 'newuser'
    fill_in 'user[email]', with: 'new@example.com'
    click_button '編集を保存'

    expect(page).to have_content('ユーザー情報を変更しました。')
    expect(page).not_to have_selector('#profilemodal', visible: true)
    expect(page).to have_content('newuser')
    expect(page).to have_content('new@example.com')
    expect(page).to have_selector("img[src*='icon_white.png']")
  end
end
