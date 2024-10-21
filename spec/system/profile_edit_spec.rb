require 'rails_helper'

RSpec.describe 'ユーザープロフィール編集', type: :system, js: true do
  include ActionView::RecordIdentifier
  let(:user) { User.create!(email: 'test@example.com', password: 'password', username: 'testuser') }

  before do
    page.driver.browser.manage.window.resize_to(475, 1000)
  end

  before do
    login_as(user, scope: :user)
  end

  it 'ユーザーがプロフィール編集モーダルを開閉できること' do
    visit edit_user_registration_path

    expect(page).to have_content('マイページ')
    find('button[data-modal-target="profilemodal"]').click
    expect(page).to have_selector('#profilemodal', visible: true)
    expect(page).to have_field('user[username]', with: user.username)
    expect(page).to have_field('user[email]', with: user.email)
    find('button[data-modal-hide="profilemodal"]').click
    expect(page).not_to have_selector('#profilemodal', visible: true)
  end

  it 'ユーザーがユーザー情報を編集できること' do
    visit edit_user_registration_path

    expect(page).to have_content('マイページ')
    find('button[data-modal-target="profilemodal"]').click
    attach_file dom_id(user, :dropzone_file), Rails.root.join('public', 'icon_white.png'), visible: false
    fill_in 'user[username]', with: 'newuser'
    fill_in 'user[email]', with: 'new@example.com'
    click_button I18n.t("devise.registrations.edit_form.update")

    expect(page).to have_content(I18n.t("devise.registrations.updated"))
    expect(page).not_to have_selector('#profilemodal', visible: true)
    expect(page).to have_content('newuser')
    expect(page).to have_content('new@example.com')
    expect(page).to have_selector("img[src*='icon_white.png']")
  end
end
