# frozen_string_literal: true

require 'rails_helper'

describe 'search keywords', type: :system do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  context 'given exactly match search keyword' do
    it 'displays searched keywords' do
      user = Fabricate(:user)
      file_path = Rails.root.join('spec', 'fabricators', 'files', 'adword_keywords.csv')

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

      assert_enqueued_with(job: GoogleScrapingJobManagementJob)

      VCR.use_cassette('with_top_position_adwords', record: :none) do
        perform_enqueued_jobs
      end

      visit keywords_path

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

  context 'given unmatch search keyword' do
    it 'displays searched keywords' do
      user = Fabricate(:user)
      file_path = Rails.root.join('spec', 'fabricators', 'files', 'adword_keywords.csv')

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

      assert_enqueued_with(job: GoogleScrapingJobManagementJob)

      VCR.use_cassette('with_top_position_adwords', record: :none) do
        perform_enqueued_jobs
      end

      visit keywords_path

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

  context 'given exactly match search keyword' do
    it 'displays searched keywords' do
      user = Fabricate(:user)
      file_path = Rails.root.join('spec', 'fabricators', 'files', 'adword_keywords.csv')

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

      assert_enqueued_with(job: GoogleScrapingJobManagementJob)

      VCR.use_cassette('with_top_position_adwords', record: :none) do
        perform_enqueued_jobs
      end

      visit keywords_path

      within '#searchForm' do
        fill_in('search', with: 'AWSSSSS')

        click_button(I18n.t('keyword.search'))
      end

      expect(page).not_to have_selector('table')
    end
  end
end
