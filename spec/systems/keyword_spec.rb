# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :system do
  describe 'redirects' do
    context 'when user does not login yet' do
      it 'redirects to login page with' do
        visit keywords_path

        expect(current_path).to eql(login_path)
      end

      it 'displays login required message' do
        visit keywords_path

        expect(page).to have_content(I18n.t('auth.login_required', page: I18n.t('keyword.page')))
      end

      it 'redirects to keywords path after logged in when come from keywords page' do
        user = Fabricate(:user)

        visit keywords_path

        within 'form' do
          fill_in('username', with: user[:username])
          fill_in('password', with: 'password')

          click_button(I18n.t('auth.login'))
        end

        expect(current_path).to eql(keywords_path)
      end
    end
  end
end
