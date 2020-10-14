# frozen_string_literal: true

class KeywordsController < ApplicationController
  before_action :ensure_authentication
  before_action :set_csv_form

  def new
    render locals: {
      csv_form: @csv_form
    }
  end

  def create
    save_result = @csv_form.save(create_params)

    if save_result.class == ActiveRecord::Result
      redirect_to new_keywords_path, notice: t('keyword.upload_csv_successfully')
    else
      redirect_to new_keywords_path, alert: save_result.errors.messages[:base][0]
    end
  end

  private

  def set_csv_form
    @csv_form = CsvImportForm.new(user: current_user)
  end

  def create_params
    params.require(:csv_import_form).permit(:file)
  end
end
