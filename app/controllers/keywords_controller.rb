# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  before_action { login_required(t('keyword.page')) }
  before_action :fetch_file, only: :create
  before_action :csv?, only: :create
  before_action :csv_keyword_in_range?, only: :create

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

  def csv?
    file_type = @file.content_type

    redirect_to keywords_path, alert: t('keyword.file_must_be_csv') unless file_type == 'text/csv'
  end

  def csv_keyword_in_range?
    keyword_count = CSV.read(@file, headers: true).count

    redirect_to keywords_path, alert: t('keyword.keyword_range') unless keyword_count.between?(1, 1000)
  end
end
