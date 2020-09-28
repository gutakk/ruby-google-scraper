# frozen_string_literal: true

class KeywordsController < ApplicationController
  def new
    @keyword = Keyword.new
  end

  def create
    @keyword = Keyword.new(keyword_params)

    if @keyword.save
      redirect_to @keyword, notice: 'Keyword was successfully created.'
    else
      render :new
    end
  end
end
