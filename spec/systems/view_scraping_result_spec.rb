# frozen_string_literal: true

require 'rails_helper'

describe 'views scraping result', type: :system do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  context 'given completed scraping status' do
    it 'displays google scraping result page' do
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

      within 'table' do
        within 'tbody' do
          expect(page).to have_selector('tr', count: 1)

          tr_list = all('tr')

          expect(tr_list[0]).to have_selector('.fa-info-circle')

          find('.fa-info-circle').click
        end
      end

      expect(current_path).to eql("#{keywords_path}/#{ActiveJob::Base.queue_adapter.enqueued_jobs[1]['arguments'][0]}")

      expect(page).not_to have_selector('div.display-2 .fa-spinner')

      expect(page).to have_selector('h1.display-3', text: 'AWS')
      expect(page).to have_selector('#topPosAdwordsCount')
      expect(page).to have_selector('#adwordsCount')
      expect(page).to have_selector('#nonAdwordsCount')
      expect(page).to have_selector('#linksCount')
      expect(page).to have_selector('#topPosAdwordLinks')
      expect(page).to have_selector('#nonAdwordLinks')
      expect(page).to have_selector('#googleHtml')

      top_position_adwords_count = find('#topPosAdwordsCount .card-body').text.to_i
      non_adwords_count = find('#nonAdwordsCount .card-body').text.to_i

      within '#topPosAdwordLinks' do
        expect(page).to have_selector('li', count: top_position_adwords_count)
      end

      within '#nonAdwordLinks' do
        expect(page).to have_selector('li', count: non_adwords_count)
      end
    end
  end

  context 'given in_queue scraping status' do
    it 'displays spinner in result page' do
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

      visit "#{keywords_path}/#{ActiveJob::Base.queue_adapter.enqueued_jobs[0]['arguments'][0][0][0]}"

      expect(page).to have_selector('h1.display-3', text: 'AWS')
      expect(page).to have_selector('div.display-2 .fa-spinner')

      expect(page).not_to have_selector('#topPosAdwordsCount')
      expect(page).not_to have_selector('#adwordsCount')
      expect(page).not_to have_selector('#nonAdwordsCount')
      expect(page).not_to have_selector('#linksCount')
      expect(page).not_to have_selector('#topPosAdwordLinks')
      expect(page).not_to have_selector('#nonAdwordLinks')
      expect(page).not_to have_selector('#googleHtml')
    end
  end
end
