# frozen_string_literal: true

require 'rails_helper'

describe 'Signup', type: :system do
  context 'validates screen' do
    it 'displays signup screen should show correct field' do
      visit signup_path

      expect(page).to have_content('Signup')

      within 'form' do
        expect(page).to have_field('user[username]')
        expect(page).to have_field('user[password]')
        expect(page).to have_field('user[password_confirmation]')
      end
    end

    it 'displays signup screen show correct label' do
      visit signup_path

      expect(page).to have_content('Signup')

      within 'form' do
        expect(page).to have_field('user[username]')
        expect(page).to have_field('user[password]')
        expect(page).to have_field('user[password_confirmation]')
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

        click_button('Signup')
      end
      expect(current_path).to eql(users_path)
      expect(page).to have_content('Account was successfully created')
    end
  end

  context 'given invalid data' do
    it 'displays password not match error when password and password confirmation are not match' do
      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')
        fill_in('user[password]', with: 'password')
        fill_in('user[password_confirmation]', with: 'drowssap')

        click_button('Signup')

        expect(page).to have_selector('#errorExplanation')
        within '#errorExplanation' do
          expect(page).to have_content('Password not match')
        end
      end
    end

    it 'displays duplicate user error when signup using existing username' do
      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')
        fill_in('user[password]', with: 'password')
        fill_in('user[password_confirmation]', with: 'password')

        click_button('Signup')
      end

      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')
        fill_in('user[password]', with: 'password')
        fill_in('user[password_confirmation]', with: 'password')

        click_button('Signup')
      end

      expect(page).to have_selector('#errorExplanation')
      within '#errorExplanation' do
        expect(page).to have_content('Username has already been taken')
      end
    end

    it 'displays both duplicate user and password not match error' do
      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')
        fill_in('user[password]', with: 'password')
        fill_in('user[password_confirmation]', with: 'password')

        click_button('Signup')
      end

      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')
        fill_in('user[password]', with: 'password')
        fill_in('user[password_confirmation]', with: 'drowssap')

        click_button('Signup')
      end

      expect(page).to have_selector('#errorExplanation')
      within '#errorExplanation' do
        expect(page).to have_content('Username has already been taken')
        expect(page).to have_content('Password not match')
      end
    end

    it 'displays required message at username when submit empty string' do
      visit signup_path

      within 'form' do
        click_button('Signup')

        message = page.find('#user_username').native.attribute('validationMessage')

        expect(message).to eq('Please fill out this field.')
      end
    end

    it 'displays required message at password when submit empty string' do
      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')

        click_button('Signup')

        message = page.find('#user_password').native.attribute('validationMessage')

        expect(message).to eq('Please fill out this field.')
      end
    end

    it 'displays required message at password_confirmation when submit empty string' do
      visit signup_path

      within 'form' do
        fill_in('user[username]', with: 'nimblehq')
        fill_in('user[password]', with: 'password')

        click_button('Signup')

        message = page.find('#user_password_confirmation').native.attribute('validationMessage')

        expect(message).to eq('Please fill out this field.')
      end
    end
  end
end
