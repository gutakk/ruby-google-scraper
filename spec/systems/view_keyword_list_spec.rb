# frozen_string_literal: true

require 'rails_helper'

describe 'views keyword list', type: :system do
  context 'given authenticated user' do
    it 'does NOT display table when no keywords' do
      Fabricate(:user)

      visit keywords_path

      system_login

      expect(current_path).to eql(keywords_path)
      expect(page).to have_content(I18n.t('keyword.no_keywords'))

      expect(page).not_to have_selector('table')
    end

    it 'displays ordered keyword list table' do
      user = Fabricate(:user)
      Fabricate(:keyword, user_id: user.id, keyword: 'Eden Hazard')
      Fabricate(:keyword, user_id: user.id, keyword: 'Lionel Messi')
      Fabricate(:keyword, user_id: user.id, keyword: 'Cristiano Ronaldo')
      Fabricate(:keyword, user_id: user.id, keyword: 'Kylian Mbappe')
      Fabricate(:keyword, user_id: user.id, keyword: 'Neymar')
      Fabricate(:keyword, user_id: user.id, keyword: 'Kevin De Bruyne')

      visit keywords_path

      system_login

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      within 'table tbody' do
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

    it "displays ONLY logged in user's keywords" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user, username: 'hello', password: 'password', password_confirmation: 'password')
      Fabricate(:keyword, user_id: user1[:id], keyword: 'Eden Hazard')

      visit keywords_path

      system_login(user1.username, 'password')

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      find('li.nav-item').click

      within '.dropdown-menu' do
        click_link(I18n.t('auth.logout'))
      end

      visit keywords_path

      system_login(user2.username, 'password')

      expect(current_path).to eql(keywords_path)
      expect(page).to have_content(I18n.t('keyword.no_keywords'))

      expect(page).not_to have_selector('table')
    end

    it 'displays ONLY 25 keywords' do
      user = Fabricate(:user)
      Fabricate.times(60, :keyword, user_id: user.id, keyword: FFaker::Name.name)

      visit keywords_path

      system_login

      expect(current_path).to eql(keywords_path)
      expect(page).to have_selector('table')

      within 'table tbody' do
        expect(page).to have_selector('tr', count: 25)
      end
    end

    context 'given in_queue status' do
      it 'displays spinning icon' do
        user = Fabricate(:user)
        Fabricate(:keyword, user_id: user.id, keyword: 'Eden Hazard')

        visit keywords_path

        system_login

        expect(current_path).to eql(keywords_path)
        expect(page).to have_selector('table')

        visit keywords_path

        within 'table tbody' do
          expect(page).to have_selector('tr', count: 1)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('.fa-spinner')
        end
      end
    end

    context 'given completed status' do
      it 'displays information icon' do
        user = Fabricate(:user)
        Fabricate(:keyword, user_id: user.id, keyword: 'Eden Hazard', status: :completed)

        visit keywords_path

        system_login

        expect(current_path).to eql(keywords_path)
        expect(page).to have_selector('table')

        within 'table tbody' do
          expect(page).to have_selector('tr', count: 1)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('.fa-info-circle')
        end
      end
    end

    context 'given failed status' do
      it 'displays error icon' do
        user = Fabricate(:user)
        Fabricate(:keyword, user_id: user.id, keyword: 'Eden Hazard', status: :failed)

        visit keywords_path

        system_login

        expect(current_path).to eql(keywords_path)
        expect(page).to have_selector('table')

        within 'table tbody' do
          expect(page).to have_selector('tr', count: 1)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('.fa-exclamation-circle')
        end
      end
    end
  end
end
