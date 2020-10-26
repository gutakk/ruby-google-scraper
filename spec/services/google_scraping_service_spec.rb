# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleScrapingService, type: :service do
  describe '#initialize' do
    it 'creates class instance' do
      google_scraping = GoogleScrapingService.new(1, 'test')

      expect(google_scraping.class).to eq(GoogleScrapingService)
      expect(google_scraping.send(:keyword_id)).to eql(1)
      expect(google_scraping.send(:keyword)).to eql('test')
    end
  end

  describe '#call!' do
    context 'given top position adwords keyword' do
      it 'updates status to completed' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.status).to eql('completed')
        end
      end

      it 'updates top position adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.top_pos_adwords).not_to be_nil
        end
      end

      it 'updates adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.adwords).not_to be_nil
        end
      end

      it 'updates non adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.non_adwords).not_to be_nil
        end
      end

      it 'updates link count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.links).not_to be_nil
        end
      end

      it 'updates html code scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.html_code).not_to be_nil
        end
      end

      it 'updates top position adword links' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.top_pos_adword_links.length).to eql(result.top_pos_adwords)
        end
      end

      it 'updates non adword links' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'AWS')
        google_scraping = GoogleScrapingService.new(keyword.id, 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          result = google_scraping.call!

          expect(result.non_adword_links.length).to eql(result.non_adwords)
        end
      end
    end

    context 'given non ascii keyword' do
      it 'does NOT raise an error when construct URI' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'สวัสดี')
        google_scraping = GoogleScrapingService.new(keyword.id, 'สวัสดี')

        expect do
          google_scraping.call!
        end.not_to raise_error(URI::InvalidURIError)
      end
    end
  end
end
