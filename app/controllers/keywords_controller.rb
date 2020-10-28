# frozen_string_literal: true

class KeywordsController < ApplicationController
  before_action :ensure_authentication
  before_action :set_csv_import_form

  # Kaminari default item per page is 25
  def index
    render locals: {
      csv_import_form: @csv_import_form,
      keywords: search_keyword
    }
  end

  def show
    keyword = Keyword.find(params[:id])

    render locals: {
      keyword: keyword
    }
  end

  def create
    if @csv_import_form.save(create_params)
      ScrapingProcessDistributingJob.perform_later(@csv_import_form.inserted_keywords.rows)

      redirect_to keywords_path, notice: t('keyword.upload_csv_successfully')
    else
      redirect_to keywords_path, alert: @csv_import_form.errors.messages[:base][0]
    end
  end

  private

  def set_csv_import_form
    @csv_import_form = CsvImportForm.new(user: current_user)
  end

  def create_params
    params.require(:csv_import_form).permit(:file)
  end

  def search_keyword
    current_user.keywords.where("keyword ILIKE '%#{params[:search]}%'").order(keyword: :asc).page(params[:page])
  end
end
