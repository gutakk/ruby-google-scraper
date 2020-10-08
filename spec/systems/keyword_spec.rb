# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :system do
  describe 'uploads csv file' do
    context 'given valid csv and user logged in' do
      it 'displays uploaded successfully message' do
        user = Fabricate(:user)
        file_path = Rails.root.join('spec', 'fabricators', 'files', 'example.csv')

        visit new_keywords_path

        within 'form' do
          fill_in('username', with: user[:username])
          fill_in('password', with: 'password')

          click_button(I18n.t('auth.login'))
        end

        attach_file('keyword[file]', file_path)

        click_button(I18n.t('keyword.upload'))

        expect(page).to have_content(I18n.t('keyword.upload_csv_successfully'))
      end
    end
  end
end
