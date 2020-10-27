# frozen_string_literal: true

require 'rails_helper'

describe 'uploads csv file', type: :system do
  context 'given valid csv and authenticated user' do
    it 'displays uploaded successfully message' do
      Fabricate(:user)
      file_path = Rails.root.join('spec', 'fabricators', 'files', 'example.csv')

      visit keywords_path

      system_login

      attach_file('csv_import_form[file]', file_path)

      click_button(I18n.t('keyword.upload'))

      expect(current_path).to eql(keywords_path)
      expect(page).to have_content(I18n.t('keyword.upload_csv_successfully'))
    end
  end
end
