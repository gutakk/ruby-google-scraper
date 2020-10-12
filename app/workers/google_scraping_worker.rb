# frozen_string_literal: true

class GoogleScrapingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    p 'HELLO FROM GOOGLE SCRAPING WORKER'
  end
end
