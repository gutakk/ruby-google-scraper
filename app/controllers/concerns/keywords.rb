# frozen_string_literal: true

module Keywords
  extend ActiveSupport::Concern

  private

  def search_keyword(user)
    search_query = "%#{params[:search]}%"

    user.keywords.where('keyword ILIKE ?', search_query).order(keyword: :asc).page(params[:page])
  end
end
