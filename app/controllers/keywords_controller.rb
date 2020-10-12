# frozen_string_literal: true

require 'csv'

class CsvValidator < ActiveModel::Validator
  def validate(record)
    file = record.instance_variable_get(:@file)

    return record.errors.add(:base, I18n.t('keyword.file_must_be_csv')) unless file.content_type == 'text/csv'
    return record.errors.add(:base, I18n.t('keyword.keyword_range')) unless CSV.read(file).count.between?(1, 1000)
  end
end

class CsvImportForm
  include ActiveModel::Model
  include ActiveModel::Validations
  validates_with CsvValidator

  def initialize(user, file)
    @user = user
    @file = file
  end

  def save
    return self unless valid?

    bulk_data = []

    CSV.foreach(@file.path) do |row|
      bulk_data << { user_id: @user.id, keyword: row[0], created_at: Time.current, updated_at: Time.current }
    end

    # rubocop:disable Rails/SkipsModelValidations
    Keyword.insert_all(bulk_data, returning: %w[id keyword])
    # rubocop:enable Rails/SkipsModelValidations
  end
end

class KeywordsController < ApplicationController
  before_action :ensure_authentication

  def new
    render locals: {
      keyword: Keyword.new
    }
  end

  def create
    form = CsvImportForm.new(current_user, params[:keyword][:file])
    save_result = form.save

    if save_result.class == ActiveRecord::Result
      return redirect_to new_keywords_path, notice: t('keyword.upload_csv_successfully')
    end

    redirect_to new_keywords_path, alert: save_result.errors.messages[:base][0]
  end
end
