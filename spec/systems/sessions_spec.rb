# frozen_string_literal: true

require 'rails_helper'

describe 'login', type: :system do
  context 'validates screen' do
    it 'displays correct contents and components' do
      visit login_path

      expect(page).to have_selector('nav')
      expect(page).to have_content(I18n.t('auth.login'))
      expect(page).to have_content(I18n.t('app.do_not_have_account_yet_html', link: I18n.t('auth.signup')))

      within 'form' do
        expect(page).to have_content(I18n.t('auth.username'))
        expect(page).to have_content(I18n.t('auth.password'))
      end
    end
  end

  context 'given valid data to login form' do
    it 'redirects to home page with greeting message' do
      user = Fabricate(:user)

      visit login_path

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql(root_path)

      within 'nav' do
        expect(page).to have_content("#{I18n.t('app.greeting')} #{user[:username]}")
      end
    end
  end
end
