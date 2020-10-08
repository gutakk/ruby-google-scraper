# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :system do
  describe 'validates screen' do
    context 'given authenticated user' do
      it 'does NOT display table when no keywords' do
        visit keywords_path

        expect(page).not_to have_selector('table')
      end
    end
  end

  describe 'redirects' do
    context 'given an unauthenticated user' do
      it 'redirects to login page with' do
        visit keywords_path

        expect(current_path).to eql(login_path)
      end

      it 'displays login required message' do
        visit keywords_path

        expect(page).to have_content(I18n.t('auth.login_required', page: I18n.t('keyword.page')))
      end

      it 'redirects to keywords path after logged in when come from keywords page' do
        user = Fabricate(:user)

        visit keywords_path

        within 'form' do
          fill_in('username', with: user[:username])
          fill_in('password', with: 'password')

          click_button(I18n.t('auth.login'))
        end

        expect(current_path).to eql(keywords_path)
      end
    end
  end

  describe 'uploads csv file' do
    context 'given valid csv and authenticated user' do
      it 'displays uploaded successfully message, keywords table and keywords must be ordered' do
        user = Fabricate(:user)
        file_path = Rails.root.join('spec', 'fabricators', 'files', 'example.csv')

        visit new_keywords_path

        within 'form' do
          fill_in('username', with: user[:username])
          fill_in('password', with: 'password')

          click_button(I18n.t('auth.login'))
        end

        attach_file('csv_import_form[file]', file_path)

        click_button(I18n.t('keyword.upload'))

        expect(page).to have_content(I18n.t('keyword.upload_csv_successfully'))
        expect(page).to have_selector('table')

        within 'table' do
          within 'tbody' do
            expect(page).to have_selector('tr', count: 6)

            within 'tr:first-child' do
              expect(page).to have_selector('td', text: 'Cristiano Ronaldo')
            end

            within 'tr:last-child' do
              expect(page).to have_selector('td', text: 'Neymar')
            end
          end
        end
      end
    end
  end
end
