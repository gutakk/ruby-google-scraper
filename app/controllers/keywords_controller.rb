# frozen_string_literal: true

require 'csv'

class CsvImportForm
  include ActiveModel::Model

  def initialize(user)
    @user = user
  end

  def save(file)
    bulk_data = []

    CSV.foreach(file.path) do |row|
      bulk_data << {
        user_id: @user.id,
        keyword: row[0],
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    # rubocop:disable Rails/SkipsModelValidations
    Keyword.insert_all(bulk_data, returning: %w[id keyword])
    # rubocop:enable Rails/SkipsModelValidations
  end
end

class KeywordsController < ApplicationController
  before_action :ensure_authentication
  before_action :fetch_file, :validate_file_type, :validate_csv, only: :create

  def new
    render locals: {
      keyword: Keyword.new
    }
  end

  def create
    form = CsvImportForm.new(current_user)

    if form.save(@file)
      redirect_to new_keywords_path, notice: t('keyword.upload_csv_successfully')
    else
      redirect_to new_keywords_path, alert: 'Something went wrong, please try again'
    end
  end

  private

  def fetch_file
    @file = params[:keyword][:file]
  end

  def validate_file_type
    file_type = @file.content_type

    redirect_to new_keywords_path, alert: t('keyword.file_must_be_csv') unless file_type == 'text/csv'
  end

  def validate_csv
    keyword_count = CSV.read(@file, headers: true).count

    redirect_to new_keywords_path, alert: t('keyword.keyword_range') unless keyword_count.between?(1, 1000)
  end
end
