# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleScrapingJobManagementJob, type: :job do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  describe '#perform' do
    context 'given valid inserted keywords' do
      it 'enqueues google scraping job manangement job' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]

        expect do
          GoogleScrapingJobManagementJob.perform_later(inserted_keywords)
        end.to have_enqueued_job(GoogleScrapingJobManagementJob)

        assert_enqueued_with(job: GoogleScrapingJobManagementJob, args: [[[1, 'hello'], [2, 'world']]])
      end

      it 'enqueues google scraping jobs' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]
        expect do
          GoogleScrapingJobManagementJob.perform_now(inserted_keywords)
        end.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(2)

        assert_enqueued_with(job: GoogleScrapingJob, args: [1, 'hello'])
        assert_enqueued_with(job: GoogleScrapingJob, args: [2, 'world'])
      end
    end
  end
end
