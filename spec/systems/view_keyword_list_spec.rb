# frozen_string_literal: true

require 'rails_helper'

describe 'views keyword list', type: :system do
  context 'given authenticated user' do
    it 'does NOT display table when no keywords' do
      user = Fabricate(:user)

      visit keywords_path

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql(keywords_path)
      expect(page).not_to have_selector('table')
    end

    it 'displays ordered keyword list table when upload successfully' do
      user = Fabricate(:user)
      file_path = Rails.root.join('spec', 'fabricators', 'files', 'example.csv')

      visit keywords_path

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      attach_file('csv_import_form[file]', file_path)

      click_button(I18n.t('keyword.upload'))

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 6)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('td', text: 'Cristiano Ronaldo')
          expect(tr_list[1]).to have_selector('td', text: 'Eden Hazard')
          expect(tr_list[2]).to have_selector('td', text: 'Kevin De Bruyne')
          expect(tr_list[3]).to have_selector('td', text: 'Kylian Mbappe')
          expect(tr_list[4]).to have_selector('td', text: 'Lionel Messi')
          expect(tr_list[5]).to have_selector('td', text: 'Neymar')
        end
      end
    end

    it "displays ONLY logged in user's keywords" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user, username: 'hello', password: 'password', password_confirmation: 'password')
      file_path = Rails.root.join('spec', 'fabricators', 'files', 'example.csv')

      visit keywords_path

      within 'form' do
        fill_in('username', with: user1[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      attach_file('csv_import_form[file]', file_path)

      click_button(I18n.t('keyword.upload'))

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      find('li.nav-item').click

      within '.dropdown-menu' do
        click_link(I18n.t('auth.logout'))
      end

      visit keywords_path

      within 'form' do
        fill_in('username', with: user2[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql(keywords_path)
      expect(page).not_to have_selector('table')
    end

    it 'displays ONLY 50 keywords' do
      user = Fabricate(:user)
      file_path = Rails.root.join('spec', 'fabricators', 'files', '60_keywords.csv')

      visit keywords_path

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      attach_file('csv_import_form[file]', file_path)

      click_button(I18n.t('keyword.upload'))

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 50)
        end
      end
    end
  end
end
