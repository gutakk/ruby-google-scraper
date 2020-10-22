# frozen_string_literal: true

require 'rails_helper'

describe 'views scraping result', type: :system do
  include ActiveJob::TestHelper

  context 'given completed scraping status' do
    it 'displays google scraping result page' do
      user = Fabricate(:user)
      keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      VCR.use_cassette('with_top_position_adwords', record: :none) do
        GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
      end

      visit "#{keywords_path}/#{keyword.id}"

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql("#{keywords_path}/#{keyword.id}")

      expect(page).to have_selector('h1.display-3', text: 'AWS')
      expect(page).to have_selector('#topPosAdwordsCount')
      expect(page).to have_selector('#adwordsCount')
      expect(page).to have_selector('#nonAdwordsCount')
      expect(page).to have_selector('#linksCount')
      expect(page).to have_selector('#topPosAdwordLinks')
      expect(page).to have_selector('#nonAdwordLinks')
      expect(page).to have_selector('#googleHtml')

      top_position_adwords_count = find('#topPosAdwordsCount .card__body').text.to_i
      non_adwords_count = find('#nonAdwordsCount .card__body').text.to_i

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
      keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      visit "#{keywords_path}/#{keyword.id}"

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql("#{keywords_path}/#{keyword.id}")

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

  context 'given failed scraping status' do
    it 'displays error message in result page' do
      user = Fabricate(:user)
      keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      allow_any_instance_of(GoogleScrapingJob).to receive(:perform).and_raise(Timeout::Error)

      VCR.use_cassette('with_top_position_adwords', record: :none) do
        perform_enqueued_jobs(only: GoogleScrapingJob) do
          GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
        end
      end

      visit "#{keywords_path}/#{keyword.id}"

      within 'form' do
        fill_in('username', with: user[:username])
        fill_in('password', with: 'password')

        click_button(I18n.t('auth.login'))
      end

      expect(current_path).to eql("#{keywords_path}/#{keyword.id}")

      expect(page).to have_selector('h1.display-3', text: 'AWS')
      expect(page).to have_content(I18n.t('app.something_went_wrong'))

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
