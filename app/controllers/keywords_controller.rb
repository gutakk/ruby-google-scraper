# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def new
    @keyword = Keyword.new
  end

  def create
    file = params[:keyword][:file]

    if CSV.read(file, headers: true).count > 1000
      redirect_to keywords_path, alert: 'Your file contain more than 1000 keywords'
    else
      CSV.foreach(file.path, headers: true) do |row|
        current_user.keywords.create(keyword: row[0])
      end

      redirect_to keywords_path, notice: 'Keyword uploaded successfully'
    end
  end
end
