# frozen_string_literal: true

class InitiateGoogleScrapingBgProcessJob < ApplicationJob
  queue_as :default

  def perform(inserted_keywords)
    inserted_keywords.each do |keyword|
      GoogleScrapingJob.perform_later(keyword[0], keyword[1])
    end
  end
end
