# frozen_string_literal: true

require 'rails_helper'

describe 'Logout', type: :system do
  context 'given logout click action' do
    it 'redirects to home page, displays logged out message and does NOT show greeting message and logout link in nav' do
      Fabricate(:user)

      visit root_path

      within 'nav' do
        click_link(I18n.t('auth.login'))
      end

      within 'form' do
        fill_in('username', with: 'nimblehq')
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      within 'nav' do
        click_link(I18n.t('auth.logout'))

        expect(page).not_to have_content(I18n.t('app.greeting'))
        expect(page).not_to have_selector('a', text: I18n.t('auth.logout'))
      end

      expect(current_path).to eql(root_path)
      expect(page).to have_content(I18n.t('auth.logout_successfully'))
    end
  end
end
