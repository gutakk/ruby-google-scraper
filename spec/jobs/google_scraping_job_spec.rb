# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleScrapingJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'enqueues google scraping job' do
      user = Fabricate(:user)
      keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      expect do
        GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
      end.to have_enqueued_job(GoogleScrapingJob)
        .and have_enqueued_job.with(keyword.id, 'AWS')
    end

    it 'creates GoogleScrapingService instance' do
      user = Fabricate(:user)
      keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      VCR.use_cassette('with_top_position_adwords', record: :none) do
        GoogleScrapingJob.perform_now(keyword.id, keyword.keyword)
      end

      result = Keyword.find(keyword.id)

      expect(result.status).to eql('completed')
    end

    context 'given error raising' do
      it 'updates status to failed' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        allow_any_instance_of(GoogleScrapingJob).to receive(:perform).and_raise(Timeout::Error)

        perform_enqueued_jobs do
          GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
        end

        result = Keyword.find(keyword.id)

        expect(result.status).to eql('failed')
      end

      it 'updates failed reason' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        allow_any_instance_of(GoogleScrapingJob).to receive(:perform).and_raise(Timeout::Error)

        perform_enqueued_jobs do
          GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
        end

        result = Keyword.find(keyword.id)

        expect(result.failed_reason).to eql('Timeout::Error')
      end
    end
  end
end
