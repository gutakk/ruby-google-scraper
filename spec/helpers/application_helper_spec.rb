# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'page title' do
    it 'returns page title without suffix' do
      expect(page_title).to eq(I18n.t('app.title'))
    end

    it 'returns page title with suffix' do
      content_for(:title_suffix) { I18n.t('auth.signup') }
      
      expect(page_title).to eq("#{I18n.t('app.title')} | #{I18n.t('auth.signup')}")
    end
  end
end
