# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  before_action :ensure_authentication
  before_action :fetch_file, only: :create
  before_action :validate_file_type, only: :create
  before_action :validate_csv, only: :create

  def new
    render locals: {
      keyword: Keyword.new
    }
  end

  def create
    Keyword.transaction do
      CSV.foreach(@file.path, headers: true) do |row|
        current_user.keywords.create(keyword: row[0])
      end
    end

    redirect_to keywords_path, notice: t('keyword.upload_csv_successfully')
  end

  private

  def fetch_file
    @file = params[:keyword][:file]
  end

  def validate_file_type
    file_type = @file.content_type

    redirect_to keywords_path, alert: t('keyword.file_must_be_csv') unless file_type == 'text/csv'
  end

  def validate_csv
    keyword_count = CSV.read(@file, headers: true).count

    redirect_to keywords_path, alert: t('keyword.keyword_range') unless keyword_count.between?(1, 1000)
  end
end
