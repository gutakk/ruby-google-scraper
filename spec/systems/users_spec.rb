# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :system do
  describe 'signup' do
    context 'validates screen' do
      it 'displays signup screen should show correct field and button' do
        visit signup_path

        within 'form' do
          expect(page).to have_field('user[username]')
          expect(page).to have_field('user[password]')
          expect(page).to have_field('user[password_confirmation]')
          expect(page).to have_button(I18n.t('auth.signup'))
        end
      end

      it 'displays signup screen show correct label and components' do
        visit signup_path

        expect(page).to have_selector('nav')
        expect(page).to have_content(I18n.t('auth.signup'))

        within 'form' do
          expect(page).to have_content(I18n.t('auth.username'))
          expect(page).to have_content(I18n.t('auth.password'))
          expect(page).to have_content(I18n.t('auth.confirm_password'))
        end
      end
    end

    context 'happy path' do
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

      it 'clicks at login link should redirect to correct page' do
        visit signup_path

        within 'main' do
          click_link(I18n.t('auth.login'))
        end

        expect(current_path).to eql(login_path)
      end
    end
  end
end
