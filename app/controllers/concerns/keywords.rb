# frozen_string_literal: true

module Keywords
  extend ActiveSupport::Concern

  private

  def search_keyword(user)
    user.keywords.where("keyword ILIKE '%#{params[:search]}%'").order(keyword: :asc).page(params[:page])
  end
end
