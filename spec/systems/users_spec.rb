# frozen_string_literal: true

require 'rails_helper'

describe 'Signup', type: :system do
  it 'displays signup screen' do
    visit new_user_path

    expect(page).to have_content('Signup')

    within 'form' do
      expect(page).to have_field('user[username]')
      expect(page).to have_field('user[password]')
      expect(page).to have_field('user[password_confirmation]')
    end
  end

  context 'given valid data' do
    it 'redirects to index page and show username that just signed up' do
      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')
        fill_in('Password', with: 'password')
        fill_in('Password confirmation', with: 'password')

        click_button('Signup')
      end
      expect(current_path).to eql(users_path)

      visit users_path
      expect(page).to have_content('Users')
      expect(page).to have_content('nimblehq')
    end
  end

  context 'given invalid data' do
    it 'displays password not match message when password and password confirmation are not match' do
      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')
        fill_in('Password', with: 'password')
        fill_in('Password confirmation', with: 'drowssap')

        click_button('Signup')

        expect(page).to have_selector('#errorExplanation')
        within '#errorExplanation' do
          expect(page).to have_content('Password confirmation doesn\'t match Password')
        end
      end
    end

    it 'displays duplicate user when signup using existing username' do
      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')
        fill_in('Password', with: 'password')
        fill_in('Password confirmation', with: 'password')

        click_button('Signup')
      end

      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')
        fill_in('Password', with: 'password')
        fill_in('Password confirmation', with: 'password')

        click_button('Signup')
      end

      expect(page).to have_selector('#errorExplanation')
      within '#errorExplanation' do
        expect(page).to have_content('Username has already been taken')
      end
    end

    it 'displays duplicate user when signup using existing username' do
      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')
        fill_in('Password', with: 'password')
        fill_in('Password confirmation', with: 'password')

        click_button('Signup')
      end

      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')
        fill_in('Password', with: 'password')
        fill_in('Password confirmation', with: 'password')

        click_button('Signup')
      end

      expect(page).to have_selector('#errorExplanation')
      within '#errorExplanation' do
        expect(page).to have_content('Username has already been taken')
      end
    end

    it 'shows required message at username when submit empty string' do
      visit new_user_path

      within 'form' do
        click_button('Signup')

        message = page.find('#user_username').native.attribute('validationMessage')

        expect(message).to eq('Please fill out this field.')
      end
    end

    it 'shows required message at password when submit empty string' do
      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')

        click_button('Signup')

        message = page.find('#user_password').native.attribute('validationMessage')

        expect(message).to eq('Please fill out this field.')
      end
    end

    it 'shows required message at password_confirmation when submit empty string' do
      visit new_user_path

      within 'form' do
        fill_in('Username', with: 'nimblehq')
        fill_in('Password', with: 'password')

        click_button('Signup')

        message = page.find('#user_password_confirmation').native.attribute('validationMessage')

        expect(message).to eq('Please fill out this field.')
      end
    end
  end
end
