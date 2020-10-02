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

  def count_top_position_adwords
    @parse_page.css('#tads > div').length
  end

  def fetch_top_position_adwords_links
    @parse_page.css('#tads > div').css('.Krnil').map { |link| link['href'] }.compact
  end

  def count_total_adwords
    @parse_page.css('#tadsb > div').length + count_top_position_adwords
  end

  def total_non_adword_results; end

  def non_adwords_links; end

  def count_links
    @parse_page.css('a').map { |link| link['href'] }.length
  end
end
