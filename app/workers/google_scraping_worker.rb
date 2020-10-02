# frozen_string_literal: true

require 'net/http'
require 'Nokogiri'

class GoogleScrapingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
    uri = URI('https://www.google.com/search?q=AWS')
    response = Net::HTTP.get(uri)
    @parse_page ||= Nokogiri::HTML(response)
  end

  def perform
  end

  private

  def 

  def total_links
    @parse_page.css('a').map { |link| link['href'] }.length
  end
end
