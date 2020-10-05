# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  has_many :adword_links, dependent: :destroy
  has_many :non_adword_links, dependent: :destroy
end
