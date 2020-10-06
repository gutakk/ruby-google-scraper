# frozen_string_literal: true

class KeywordsController < ApplicationController
  before_action :ensure_authentication
  before_action :set_csv_import_form

  def index
    render locals: {
      csv_import_form: @csv_import_form,
      keywords: current_user.keywords.order(keyword: :asc).limit(50) # TODOs pagination (new ticket)
    }
  end

  def show
    keyword = Keyword.find_by(id: params[:id])

    render locals: {
      keyword: keyword,
      adword_links: keyword.adword_links.all,
      non_adword_links: keyword.non_adword_links.all
    }
  end

  def create
    if @csv_import_form.save(create_params)
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
end
