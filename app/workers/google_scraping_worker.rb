# frozen_string_literal: true

require 'httparty'
require 'Nokogiri'

class GoogleScrapingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
    uri = URI('https://www.google.com/search?q=AWS')
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) ' \
    'Chrome/85.0.4183.121 Safari/537.36'

    response = HTTParty.get(uri, { headers: { 'User-Agent': user_agent } })
    @parse_page ||= Nokogiri::HTML(response)
  end

  def perform; end

  private

  def total_top_position_adwords; end

  def top_position_adwords_links; end

  def total_adwords; end

  def total_non_adword_results; end

  def non_adwords_links; end

  def total_links
    @parse_page.css('a').map { |link| link['href'] }.length
  end
end
