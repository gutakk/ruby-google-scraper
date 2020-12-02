# frozen_string_literal: true

Fabricator(:user) do
  username 'nimblehq'
  password 'password'
  password_confirmation 'password'
end
