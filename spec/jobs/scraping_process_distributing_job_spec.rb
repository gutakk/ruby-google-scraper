# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrapingProcessDistributingJob, type: :job do
  describe '#perform' do
    context 'given valid inserted keywords' do
      it 'enqueues scraping process distributing job' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]

        expect do
          ScrapingProcessDistributingJob.perform_later(inserted_keywords)
        end.to have_enqueued_job(ScrapingProcessDistributingJob)
          .and have_enqueued_job.with([[1, 'hello'], [2, 'world']])
      end

      it 'enqueues google scraping jobs' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]

        # rubocop:disable Layout/MultilineMethodCallIndentation
        expect do
          ScrapingProcessDistributingJob.perform_now(inserted_keywords)
        end.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(2)
          .and have_enqueued_job.with(1, 'hello')
          .and have_enqueued_job.with(2, 'world')
        # rubocop:enable Layout/MultilineMethodCallIndentation
      end
    end

    context 'given NO inserted keyword' do
      it 'enqueues scraping process distributing job when inserted keyword is nil' do
        expect do
          ScrapingProcessDistributingJob.perform_later(nil)
        end.to have_enqueued_job(ScrapingProcessDistributingJob)
      end

      it 'raises error when enqueue google scraping job when inserted keyword is nil' do
        expect do
          ScrapingProcessDistributingJob.perform_now(nil)
        end.to raise_error(NoMethodError)
      end

      it 'enqueues scraping process distributing job when inserted keyword is empty' do
        expect do
          ScrapingProcessDistributingJob.perform_later([])
        end.to have_enqueued_job(ScrapingProcessDistributingJob)
      end

      it 'does NOT enqueue google scraping job when inserted keyword is empty' do
        expect do
          ScrapingProcessDistributingJob.perform_now([])
        end.not_to have_enqueued_job(GoogleScrapingJob)
      end
    end
  end
end
