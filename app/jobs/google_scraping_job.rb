# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

class GoogleScrapingJob < ApplicationJob
  retry_on Exception do |job, error|
    keyword_id = job.arguments[0]

    Keyword.update(
      keyword_id,
      status: :failed,
      failed_reason: error
    )
  end

  def perform(keyword_id, keyword)
    scrap_from_google(keyword)
    store_result(keyword_id)
  end

  private

  def scrap_from_google(keyword)
    uri = URI.parse("https://www.google.com/search?q=#{CGI.escape(keyword)}")
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) ' \
    'Chrome/85.0.4183.121 Safari/537.36'

    response = HTTParty.get(uri, { headers: { 'User-Agent': user_agent } })
    @parse_page = Nokogiri::HTML(response)
  end

  def store_result(keyword_id)
    Keyword.update(
      keyword_id,
      status: :completed,
      top_pos_adwords: count_top_position_adwords,
      adwords: count_total_adwords,
      non_adwords: count_non_adwords,
      links: count_links,
      html_code: @parse_page,
      top_pos_adword_links: fetch_top_position_adwords_links,
      non_adword_links: fetch_non_adword_links
    )
  end

  def count_top_position_adwords
    @parse_page.css('#tads > div').length
  end

  def fetch_top_position_adwords_links
    @parse_page.css('#tads > div').css('.Krnil').map { |link| link['href'] }.compact
  end

  def count_total_adwords
    @parse_page.css('#tadsb > div').length + count_top_position_adwords
  end

  def count_non_adwords
    @parse_page.css('#rso > div[class=g]').length
  end

  def fetch_non_adword_links
    @parse_page.css('#rso > div[class=g]').css('.yuRUbf > a').map { |link| link['href'] }.compact
  end

  def count_links
    @parse_page.css('a').map { |link| link['href'] }.length
  end
end
