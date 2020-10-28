# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApplicationController
      before_action :doorkeeper_authorize!
      before_action :current_user

      def index
        render json: search_keyword, status: :ok
      end

      private

      def current_user
        @user = User.find(doorkeeper_token.resource_owner_id)
      end

      def search_keyword
        @user.keywords.where("keyword ILIKE '%#{params[:search]}%'").order(keyword: :asc).page(params[:page])
      end
    end
  end
end
