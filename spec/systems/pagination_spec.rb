# frozen_string_literal: true

require 'rails_helper'

describe 'pagination', type: :system do
  ActiveJob::Base.queue_adapter = :test

  context 'given 60 keywords csv' do
    # 25 keywords per page
    it 'displays first page' do
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

      paginations = find('.pagination')

      within paginations do
        expect(page).to have_content('1')
        expect(page).to have_content('2')
        expect(page).to have_content('3')
        expect(page).to have_content(I18n.t('pagination.next'))

        expect(page).not_to have_content('4')
        expect(page).not_to have_content(I18n.t('pagination.prev'))
      end

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 25)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('td', text: 'Addie Waters')
        end
      end
    end

    it 'displays second page' do
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

      visit keywords_path(page: 2)

      expect(page).to have_current_path(keywords_path(page: 2))

      paginations = find('.pagination')

      within paginations do
        expect(page).to have_content('1')
        expect(page).to have_content('2')
        expect(page).to have_content('3')
        expect(page).to have_content(I18n.t('pagination.next'))
        expect(page).to have_content(I18n.t('pagination.prev'))
      end

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 25)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('td', text: 'Henrietta Taylor')
        end
      end
    end

    it 'displays third page' do
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

      visit keywords_path(page: 3)

      expect(page).to have_current_path(keywords_path(page: 3))

      paginations = find('.pagination')

      within paginations do
        expect(page).to have_content('1')
        expect(page).to have_content('2')
        expect(page).to have_content('3')
        expect(page).to have_content(I18n.t('pagination.prev'))

        expect(page).not_to have_content(I18n.t('pagination.next'))
      end

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 10)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('td', text: 'Rhoda McDonald')
        end
      end
    end

    it 'does NOT display keywords table when go to page 4' do
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

      visit keywords_path(page: 4)

      expect(page).not_to have_selector('table')

      expect(page).to have_content(I18n.t('keyword.no_keywords'))
    end
  end
end
