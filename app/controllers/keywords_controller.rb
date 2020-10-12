# frozen_string_literal: true

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
