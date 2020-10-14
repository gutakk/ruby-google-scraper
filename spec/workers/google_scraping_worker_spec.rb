# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
require 'vcr'

RSpec.describe GoogleScrapingWorker, type: :worker do
  describe 'performs task' do
    context 'given valid keyword' do
      it 'creates google scraping sidekiq job' do
        VCR.use_cassette('google_scraping', record: :none) do
          user = Fabricate(:user)
          keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

          expect do
            GoogleScrapingWorker.perform_async(
              keyword_id: keyword.id,
              keyword: keyword.keyword
            )
          end.to change(GoogleScrapingWorker.jobs, :size).by(1)
        end
      end

      it 'updates status to processed' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          result = Keyword.find_by(id: keyword.id)

          expect(result.status).to eql('processed')
        end
      end

      it 'updates top position adword count scraping result' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          result = Keyword.find_by(id: keyword.id)

          expect(result.top_pos_adwords).not_to be_nil
        end
      end

      it 'updates adword count scraping result' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          result = Keyword.find_by(id: keyword.id)

          expect(result.adwords).not_to be_nil
        end
      end

      it 'updates non adword count scraping result' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          result = Keyword.find_by(id: keyword.id)

          expect(result.non_adwords).not_to be_nil
        end
      end

      it 'updates link count scraping result' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          result = Keyword.find_by(id: keyword.id)

          expect(result.links).not_to be_nil
        end
      end

      it 'updates html code scraping result' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          result = Keyword.find_by(id: keyword.id)

          expect(result.html_code).not_to be_nil
        end
      end

      it 'creates top position adword links' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          inserted_keyword = Keyword.find_by(id: keyword.id)
          result = TopPositionAdwordLink.where(keyword_id: keyword.id)

          expect(inserted_keyword.top_pos_adwords).to eql(result.length)
        end
      end

      it 'creates non adword links' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          inserted_keyword = Keyword.find_by(id: keyword.id)
          result = NonAdwordLink.where(keyword_id: keyword.id)

          expect(inserted_keyword.non_adwords).to eql(result.length)
        end
      end
    end

    context 'given error raising' do
      it 'rollback the transaction when create top position adword links is raised' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          allow(subject).to receive(:create_top_position_adword_links).and_raise(ActiveRecord::Rollback)

          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

          result = Keyword.find_by(id: keyword.id)

          expect(result.status).to eql('processing')
          expect(result.top_pos_adwords).to be_nil
          expect(result.adwords).to be_nil
          expect(result.non_adwords).to be_nil
          expect(result.links).to be_nil
          expect(result.html_code).to be_nil
        end
      end

      it 'rollback the transaction when create non adword links is raised' do
        subject { new GoogleScrapingWorker }

        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        VCR.use_cassette('google_scraping', record: :none) do
          allow(subject).to receive(:create_non_adword_links).and_raise(ActiveRecord::Rollback)

          subject.perform(
            keyword_id: keyword.id,
            keyword: keyword.keyword
          )

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
end
