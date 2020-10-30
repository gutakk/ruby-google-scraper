# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :username

  has_many :keywords
end
