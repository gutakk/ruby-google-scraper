# frozen_string_literal: true

require 'rails_helper'

describe 'Logout', type: :system do
  it 'redirects to home page, displays logged out message and does NOT show greeting message and logout link in nav dropdown' do
    Fabricate(:user)

    visit root_path

    within 'nav' do
      click_link(I18n.t('auth.login'))
    end

    system_login

    find('li.nav-item').click

    within '.dropdown-menu' do
      click_link(I18n.t('auth.logout'))
    end

    within 'nav' do
      expect(page).not_to have_content(I18n.t('app.greeting'))
    end

    expect(page).not_to have_selector('li', class: 'nav-item')
    expect(current_path).to eql(root_path)
    expect(page).to have_content(I18n.t('auth.logout_successfully'))
  end
end
