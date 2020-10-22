# frozen_string_literal: true

require 'rails_helper'

describe 'search keywords', type: :system do
  ActiveJob::Base.queue_adapter = :test

  context 'given exactly match search keyword' do
    it 'displays searched keywords' do
      user = Fabricate(:user)
      Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      visit keywords_path

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      within '#searchForm' do
        fill_in('search', with: 'AWS')

        click_button(I18n.t('keyword.search'))
      end

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 1)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('td', text: 'AWS')
        end
      end
    end
  end

  context 'given partially match search keyword' do
    it 'displays searched keywords' do
      user = Fabricate(:user)
      Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      visit keywords_path

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      within '#searchForm' do
        fill_in('search', with: 'AW')

        click_button(I18n.t('keyword.search'))
      end

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 1)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('td', text: 'AWS')
        end
      end
    end
  end

  context 'given unmatch search keyword' do
    it 'displays searched keywords' do
      user = Fabricate(:user)
      Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      visit keywords_path

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      within '#searchForm' do
        fill_in('search', with: 'AWSSSSS')

        click_button(I18n.t('keyword.search'))
      end

      expect(page).not_to have_selector('table')

      expect(page).to have_content(I18n.t('keyword.no_keywords'))
    end
  end
end
