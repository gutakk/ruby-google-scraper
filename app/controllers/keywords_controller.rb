# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def new
    render locals: {
      keyword: Keyword.new
    }
  end

  def create
    @file = params[:keyword][:file]

    if CSV.read(@file, headers: true).count.between?(1, 1000)
      import_keywords

      redirect_to keywords_path, notice: t('app.upload_csv_successfully')
    else
      redirect_to keywords_path, alert: t('app.invalid_csv')
    end
  end

  private

  def import_keywords
    Keyword.transaction do
      CSV.foreach(@file.path, headers: true) do |row|
        current_user.keywords.create(keyword: row[0])
      end
    end
  end
end
