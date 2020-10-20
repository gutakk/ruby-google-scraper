# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InitiateGoogleScrapingBgProcessJob, type: :job do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  describe '#perform' do
    context 'given valid inserted keywords' do
      it 'enqueues initiate google scraping background process job' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]

        expect do
          InitiateGoogleScrapingBgProcessJob.perform_later(inserted_keywords)
        end.to have_enqueued_job(InitiateGoogleScrapingBgProcessJob)

        assert_enqueued_with(job: InitiateGoogleScrapingBgProcessJob, args: [[[1, 'hello'], [2, 'world']]])
      end

      it 'enqueues google scraping jobs' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]
        expect do
          InitiateGoogleScrapingBgProcessJob.perform_now(inserted_keywords)
        end.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(2)

        assert_enqueued_with(job: GoogleScrapingJob, args: [1, 'hello'])
        assert_enqueued_with(job: GoogleScrapingJob, args: [2, 'world'])
      end
    end
  end
end
