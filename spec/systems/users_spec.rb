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
end
