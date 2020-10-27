# frozen_string_literal: true

require 'rails_helper'

describe 'pagination', type: :system do
  context 'given 60 keywords' do
    # 25 keywords per page
    it 'displays first page' do
      user = Fabricate(:user)
      Fabricate.times(60, :keyword, user_id: user.id, keyword: FFaker::Name.name)

      visit keywords_path

      system_login

      paginations = find('.pagination')

      within paginations do
        expect(page).to have_content('1')
        expect(page).to have_content('2')
        expect(page).to have_content('3')
        expect(page).to have_content(I18n.t('pagination.next'))

        expect(page).not_to have_content('4')
        expect(page).not_to have_content(I18n.t('pagination.prev'))
      end

      within 'table tbody' do
        expect(page).to have_selector('tr', count: 25)
      end
    end

    it 'displays second page' do
      user = Fabricate(:user)
      Fabricate.times(60, :keyword, user_id: user.id, keyword: FFaker::Name.name)

      visit keywords_path(page: 2)

      system_login

      expect(page).to have_current_path(keywords_path(page: 2))

      paginations = find('.pagination')

      within paginations do
        expect(page).to have_content('1')
        expect(page).to have_content('2')
        expect(page).to have_content('3')
        expect(page).to have_content(I18n.t('pagination.next'))
        expect(page).to have_content(I18n.t('pagination.prev'))
      end

      within 'table tbody' do
        expect(page).to have_selector('tr', count: 25)
      end
    end

    it 'displays third page' do
      user = Fabricate(:user)
      Fabricate.times(60, :keyword, user_id: user.id, keyword: FFaker::Name.name)

      visit keywords_path(page: 3)

      system_login

      expect(page).to have_current_path(keywords_path(page: 3))

      paginations = find('.pagination')

      within paginations do
        expect(page).to have_content('1')
        expect(page).to have_content('2')
        expect(page).to have_content('3')
        expect(page).to have_content(I18n.t('pagination.prev'))

        expect(page).not_to have_content(I18n.t('pagination.next'))
      end

      within 'table tbody' do
        expect(page).to have_selector('tr', count: 10)
      end
    end

    it 'does NOT display keywords table when go to page 4' do
      user = Fabricate(:user)
      Fabricate.times(60, :keyword, user_id: user.id, keyword: FFaker::Name.name)

      visit keywords_path(page: 4)

      system_login

      expect(page).not_to have_selector('table')

      expect(page).to have_content(I18n.t('keyword.no_keywords'))
    end
  end
end
