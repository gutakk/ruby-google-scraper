# frozen_string_literal: true

require 'rails_helper'

describe 'signup', type: :system do
  context 'validates screen' do
    it 'displays correct contents and components' do
      visit signup_path

      expect(page).to have_selector('nav')
      expect(page).to have_content(I18n.t('auth.signup'))
      expect(page).to have_content(I18n.t('app.already_have_account_html', link: I18n.t('auth.login')))

      within 'form' do
        expect(page).to have_content(I18n.t('auth.username'))
        expect(page).to have_content(I18n.t('auth.password'))
        expect(page).to have_content(I18n.t('auth.confirm_password'))
      end
    end
  end

  context 'given valid data to signup form' do
    it 'redirects to login page and show flash message' do
      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')
        fill_in('user[password]', with: 'password')
        fill_in('user[password_confirmation]', with: 'password')

        click_button(I18n.t('auth.signup'))
      end

      expect(current_path).to eql(login_path)
      expect(page).to have_content(I18n.t('auth.signup_successfully'))
    end
  end
end
