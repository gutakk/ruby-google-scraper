# frozen_string_literal: true

class User < ApplicationRecord
  has_many :keywords, dependent: :destroy

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
