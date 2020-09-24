# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :system do
  describe 'Signup feature' do
    context 'validates screen' do
      it 'displays signup screen should show correct field and button' do
        visit signup_path

        expect(page).to have_content(I18n.t('auth.signup'))

        within 'form' do
          expect(page).to have_field('user[username]')
          expect(page).to have_field('user[password]')
          expect(page).to have_field('user[password_confirmation]')
          expect(page).to have_button(I18n.t('auth.signup'))
        end
      end

      it 'displays signup screen show correct label' do
        visit signup_path

        expect(page).to have_content(I18n.t('auth.signup'))

        within 'form' do
          expect(page).to have_content(I18n.t('auth.username'))
          expect(page).to have_content(I18n.t('auth.password'))
          expect(page).to have_content(I18n.t('auth.confirm_password'))
        end
      end
    end

    context 'given valid data' do
      it 'redirects to index page and show flash message' do
        visit signup_path

        within 'form' do
          fill_in('user[username]', with: 'nimblehq')
          fill_in('user[password]', with: 'password')
          fill_in('user[password_confirmation]', with: 'password')

          click_button(I18n.t('auth.signup'))
        end
        expect(current_path).to eql(root_path)
        expect(page).to have_content(I18n.t('auth.signed_up_successfully'))
      end
    end
  end
end
