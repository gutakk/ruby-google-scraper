# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  def self.import(file, current_user)
    Keyword.transaction do
      CSV.foreach(file.path, headers: true) do |row|
        current_user.keywords.create(keyword: row[0])
      end
    end
  end
end
