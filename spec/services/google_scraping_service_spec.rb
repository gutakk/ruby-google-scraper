# frozen_string_literal: true

require 'rails_helper'
require 'vcr'

RSpec.describe GoogleScrapingService, type: :service do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  describe '#perform' do
    context 'given valid keyword (with top position adwords)' do
      it 'updates status to completed' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.status).to eql('completed')
      end

      it 'updates top position adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.top_pos_adwords).not_to be_nil
      end

      it 'updates adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.adwords).not_to be_nil
      end

      it 'updates non adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.non_adwords).not_to be_nil
      end

      it 'updates link count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.links).not_to be_nil
      end

      it 'updates html code scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.html_code).not_to be_nil
      end

      it 'updates top position adword links' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.top_pos_adword_links.length).to eql(result.top_pos_adwords)
      end

      it 'updates non adword links' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.non_adword_links.length).to eql(result.non_adwords)
      end
    end

    context 'given error raising' do
      it 'updates status to failed' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        allow_any_instance_of(GoogleScrapingJob).to receive(:perform).and_raise(Timeout::Error)

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          assert_performed_jobs 5 do
            GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
          end
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.status).to eql('failed')
      end

      it 'adds failed reason' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        allow_any_instance_of(GoogleScrapingJob).to receive(:perform).and_raise(Timeout::Error)

        VCR.use_cassette('with_top_position_adwords', record: :none) do
          assert_performed_jobs 5 do
            GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
          end
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.failed_reason).to eql('Timeout::Error')
      end
    end

    context 'given non ascii keyword' do
      it 'does NOT raise an error when construct URI' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'สวัสดี')

        VCR.use_cassette('non_ascii_keyword', record: :none) do
          expect do
            GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
          end.not_to raise_error(URI::InvalidURIError)
        end
      end
    end
  end
end
