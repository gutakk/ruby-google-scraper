# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsController, type: :controller do
  describe 'GET#new' do
    # Logged in required before access to keywords controller
    before(:each) do |test|
      if test.metadata[:logged_in]
        user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')
        session[:user_id] = user[:id]
      end

      get :new
    end

    it 'renders a successful response', :logged_in do
      expect(response).to be_successful
    end

    it 'renders a correct template', :logged_in do
      expect(response).to render_template(:new)
    end

    it 'redirect to login when not login' do
      expect(response).to redirect_to(login_path)
    end
  end
end
