# frozen_string_literal: true

class GoogleScrapingJobWorker
  include Sidekiq::Worker

  def perform(inserted_keywords)
    inserted_keywords.each do |keyword|
      GoogleScrapingWorker.perform_async(keyword[0])
    end
  end
end
