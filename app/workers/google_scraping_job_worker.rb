# frozen_string_literal: true

class GoogleScrapingJobWorker
  include Sidekiq::Worker

  def perform(inserted_keywords)
    inserted_keywords.each do |keyword|
      GoogleScrapingWorker.perform_async(
        keyword_id: keyword[0],
        keyword: keyword[1]
      )
    end
  end
end
