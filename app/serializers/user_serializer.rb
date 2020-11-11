# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :username

  has_many :keywords
end
