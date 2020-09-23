# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation', :aggregate_failures do
    context 'presence' do
      it { should validate_presence_of(:username) }

      it { should validate_presence_of(:password) }

      it { should validate_presence_of(:password_confirmation) }
    end

    context 'uniqueness' do
      subject { User.new(username: 'nimblehq', password: 'password', password_confirmation: 'password') }

      it { should validate_uniqueness_of(:username) }
    end

    context 'confirmation' do
      it { should validate_confirmation_of(:password).with_message(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')) }
    end

    context 'has secure password' do
      it { should have_secure_password }
    end
  end
end
