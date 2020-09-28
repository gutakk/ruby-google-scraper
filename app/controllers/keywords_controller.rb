# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def new
    @keyword = Keyword.new
  end

  def create
    file = params[:keyword][:file]

    if CSV.read(file, headers: true).between?(1, 1000)
      CSV.foreach(file.path, headers: true) do |row|
        current_user.keywords.create(keyword: row[0])
      end

      redirect_to keywords_path, notice: 'Keyword uploaded successfully'
    else
      redirect_to keywords_path, alert: 'Your CSV file must contain between 1 to 1000 keywords'
    end
  end
end
