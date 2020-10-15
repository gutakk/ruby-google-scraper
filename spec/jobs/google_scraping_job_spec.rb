# frozen_string_literal: true

require 'rails_helper'
require 'vcr'

RSpec.describe GoogleScrapingJob, type: :job do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  describe '#perform' do
    context 'given valid keyword' do
      it 'enqueues google scraping job' do
        VCR.use_cassette('google_scraping', record: :none) do
          user = Fabricate(:user)
          keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

          expect do
            GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
          end.to have_enqueued_job(GoogleScrapingJob)

          assert_enqueued_with(job: GoogleScrapingJob, args: [keyword.id, 'AWS'])
        end
      end

      it 'updates status to processed' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.status).to eql('processed')
      end

      it 'updates top position adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.top_pos_adwords).not_to be_nil
      end

      it 'updates adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.adwords).not_to be_nil
      end

      it 'updates non adword count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.non_adwords).not_to be_nil
      end

      it 'updates link count scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.links).not_to be_nil
      end

      it 'updates html code scraping result' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.html_code).not_to be_nil
      end

      it 'creates top position adword links' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        inserted_keyword = Keyword.find_by(id: keyword.id)
        result = TopPositionAdwordLink.where(keyword_id: keyword.id)

        expect(inserted_keyword.top_pos_adwords).to eql(result.length)
      end

      it 'creates non adword links' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
        end

        inserted_keyword = Keyword.find_by(id: keyword.id)
        result = NonAdwordLink.where(keyword_id: keyword.id)

        expect(inserted_keyword.non_adwords).to eql(result.length)
      end
    end

    context 'given error raising' do
      it 'rollback the transaction when create top position adword links is raised' do
        subject { new GoogleScrapingJob }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        allow(subject).to receive(:create_top_position_adword_links).and_raise(ActiveRecord::Rollback)

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.status).to eql('processing')
        expect(result.top_pos_adwords).to be_nil
        expect(result.adwords).to be_nil
        expect(result.non_adwords).to be_nil
        expect(result.links).to be_nil
        expect(result.html_code).to be_nil
      end

      it 'rollback the transaction when create non adword links is raised' do
        subject { new GoogleScrapingJob }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        allow(subject).to receive(:create_non_adword_links).and_raise(ActiveRecord::Rollback)

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(keyword.id, keyword.keyword)
        end

        result = Keyword.find_by(id: keyword.id)

        expect(result.status).to eql('processing')
        expect(result.top_pos_adwords).to be_nil
        expect(result.adwords).to be_nil
        expect(result.non_adwords).to be_nil
        expect(result.links).to be_nil
        expect(result.html_code).to be_nil
      end
    end
  end
end
