# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include Localization
    end
  end
end
