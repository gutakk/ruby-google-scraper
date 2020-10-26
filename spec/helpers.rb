# frozen_string_literal: true

module Helpers
  def strip_tags(string)
    ActionController::Base.helpers.strip_tags(string)
  end

  def system_login(username = 'nimblehq', password = 'password')
    within 'form' do
      fill_in('username', with: username)
      fill_in('password', with: password)

      click_button(I18n.t('auth.login'))
    end
  end
end
