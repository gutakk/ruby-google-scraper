# frozen_string_literal: true

class User < ApplicationRecord
  has_many :keywords, dependent: :destroy
  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant', dependent: :delete_all
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', dependent: :delete_all

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
