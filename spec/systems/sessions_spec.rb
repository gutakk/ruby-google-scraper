# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  describe 'login' do
    context 'validates screen' do
      it 'displays correct contents and components' do
        visit login_path

        expect(page).to have_selector('nav')
        expect(page).to have_content(I18n.t('auth.login'))
        expect(page).to have_content("#{I18n.t('app.do_not_have_account_yet')} #{I18n.t('auth.signup')}")

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

  describe 'logout' do
    context 'when logout clicked' do
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
end
