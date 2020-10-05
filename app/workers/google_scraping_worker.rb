# frozen_string_literal: true

require 'httparty'
require 'Nokogiri'

class GoogleScrapingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    keywords = Keyword.all.where(status: 'processing')

    Keyword.transaction do
      keywords.each do |keyword|
        uri = URI("https://www.google.com/search?q=#{keyword.keyword}")
        user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) ' \
        'Chrome/85.0.4183.121 Safari/537.36'

        response = HTTParty.get(uri, { headers: { 'User-Agent': user_agent } })
        @parse_page = Nokogiri::HTML(response)

        keyword.update(
          status: 'processed',
          top_pos_adwords: count_top_position_adwords,
          non_adwords: count_non_adwords,
          links: count_links,
          html_code: @parse_page
        )

        fetch_top_position_adwords_links.each do |link|
          keyword.adword_links.create(link: link)
        end

        fetch_non_adwords_links.each do |link|
          keyword.non_adword_links.create(link: link)
        end

        sleep(1)
      end
    end
  end

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

  def count_non_adwords
    @parse_page.css('#rso > div[class=g]').length
  end

  def fetch_non_adwords_links
    @parse_page.css('#rso > div[class=g]').css('.yuRUbf > a').map { |link| link['href'] }.compact
  end

  def count_links
    @parse_page.css('a').map { |link| link['href'] }.length
  end
end
