# frozen_string_literal: true

class KeywordSerializer < ApplicationSerializer
  attributes :keyword,
             :status,
             :top_pos_adwords,
             :adwords,
             :non_adwords,
             :links,
             :html_code,
             :top_pos_adword_links,
             :non_adword_links,
             :failed_reason

  belongs_to :user
end
