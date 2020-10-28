# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApplicationController
      include Keywords

      before_action :doorkeeper_authorize!
      before_action :load_user
      before_action :set_csv_import_form, only: :create

      def index
        render json: search_keyword(@user), status: :ok
      end

      def show
        render json: @user.keywords.find(params[:id]), status: :ok
      end

      def create
        if @csv_import_form.save(create_params)
          ScrapingProcessDistributingJob.perform_later(@csv_import_form.inserted_keywords.rows)

          render_successful_response(I18n.t('keyword.upload_csv_successfully'), :ok)
        else
          render_error_response(
            I18n.t('keyword.upload_csv_unsuccessfully'),
            @csv_import_form.errors.messages[:base][0],
            :bad_request
          )
        end
      end

      private

      def load_user
        @user = User.find(doorkeeper_token.resource_owner_id)
      end

      def set_csv_import_form
        @csv_import_form = CsvImportForm.new(user: @user)
      end

      def create_params
        params.permit(:file)
      end
    end
  end
end
