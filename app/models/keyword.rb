# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  enum status: { in_queue: 0, completed: 1, failed: 2 }
end
