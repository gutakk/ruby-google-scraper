# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  has_many :top_position_adword_links, dependent: :destroy
  has_many :non_adword_links, dependent: :destroy

  enum status: { in_queue: 0, completed: 1, failed: 2 }
end
