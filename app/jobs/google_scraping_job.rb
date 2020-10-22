# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

class GoogleScrapingJob < ApplicationJob
  # default retry attempts is 5 (https://edgeapi.rubyonrails.org/classes/ActiveJob/Exceptions/ClassMethods.html#method-i-retry_on)
  retry_on Exception do |job, error|
    keyword_id = job.arguments[0]

    Keyword.update(
      keyword_id,
      status: :failed,
      failed_reason: error
    )
  end

  def perform(keyword_id, keyword)
    GoogleScrapingService.new(keyword_id, keyword).call!
  end
end
