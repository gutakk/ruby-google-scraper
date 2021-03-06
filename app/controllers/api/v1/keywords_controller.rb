# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApplicationController
      include Keywords

      before_action :set_csv_import_form, only: :create

      def index
        render json: KeywordSerializer.new(search_keyword(current_user)).serializable_hash, status: :ok
      end

      def show
        render json: KeywordSerializer.new(current_user.keywords.find(params[:id])).serializable_hash, status: :ok
      rescue ActiveRecord::RecordNotFound
        render_error_response(
          detail: I18n.t('keyword.not_found_with_id', id: params[:id]),
          status: :not_found
        )
      end

      def create
        if @csv_import_form.save(create_params)
          ScrapingProcessDistributingJob.perform_later(@csv_import_form.inserted_keywords.rows)

          render status: :no_content
        else
          render_error_response(
            detail: @csv_import_form.errors.messages[:base][0],
            status: :bad_request
          )
        end
      end

      private

      def set_csv_import_form
        @csv_import_form = CsvImportForm.new(user: current_user)
      end

      def create_params
        params.permit(:file)
      end
    end
  end
end
