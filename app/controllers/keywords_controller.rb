# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def new
    @keyword = Keyword.new
  end

  def create
    CSV.foreach(params[:keyword][:file].path, headers: true) do |row|
      current_user.keywords.create(keyword: row[0])
    end

    redirect_to keywords_path, notice: 'Keyword uploaded successfully'
  end
end
