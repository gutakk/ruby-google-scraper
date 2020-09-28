# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  describe 'login' do
    context 'validates screen' do
      it 'login screen should show correct field and button' do
        visit login_path

        within 'form' do
          expect(page).to have_field('username')
          expect(page).to have_field('password')
          expect(page).to have_button(I18n.t('auth.login'))
        end
      end

      it 'login screen should show correct label and components' do
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

    context 'happy path' do
      it 'given valid data should redirect to index page with greeting message' do
        user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')

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

      it 'clicks at signup link should redirect to correct page' do
        visit login_path

        within 'main' do
          click_link(I18n.t('auth.signup'))
        end

        expect(current_path).to eql(signup_path)
      end
    end
  end

  describe 'logout' do
    before(:each) do
      Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')

      visit root_path

      within 'nav' do
        click_link(I18n.t('auth.login'))
      end

      within 'form' do
        fill_in('username', with: 'nimblehq')
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end
    end

    it 'should have signout link in nav when session exist' do
      within 'nav' do
        expect(page).to have_selector('a', text: I18n.t('auth.logout'))
      end
    end

    context 'logout clicked' do
      before(:each) do
        within 'nav' do
          click_link(I18n.t('auth.logout'))
        end
      end

      it 'clicks logout should show logged out message' do
        expect(page).to have_content(I18n.t('auth.logout_successfully'))
      end

      it 'clicks logout should not show greeting message and logout link in nav' do
        within 'nav' do
          expect(page).not_to have_content(I18n.t('app.greeting'))
          expect(page).not_to have_selector('a', text: I18n.t('auth.logout'))
        end
      end
    end
  end
end
