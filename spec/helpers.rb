# frozen_string_literal: true

module Helpers
  def strip_tags(string)
    ActionController::Base.helpers.strip_tags(string)
  end
end
