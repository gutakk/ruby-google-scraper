# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe GoogleScrapingJobWorker, type: :worker do
  describe 'performs async task' do
    context 'given valid inserted keywords' do
      it 'creates google scraping job sidekiq job' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]

        expect do
          GoogleScrapingJobWorker.perform_async(inserted_keywords)
        end.to change(GoogleScrapingJobWorker.jobs, :size).by(1)
      end

      it 'creates google scraping sidekiq jobs' do
        inserted_keywords = [
          [1, 'hello'],
          [2, 'world']
        ]

        GoogleScrapingJobWorker.perform_async(inserted_keywords)

        expect do
          GoogleScrapingJobWorker.drain
        end.to change(GoogleScrapingWorker.jobs, :size).by(2)
      end
    end
  end
end
