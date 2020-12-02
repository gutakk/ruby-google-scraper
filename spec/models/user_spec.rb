# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    context 'has many' do
      it { is_expected.to have_many(:keywords) }
    end
  end

  describe 'validation' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:username) }

      it { is_expected.to validate_presence_of(:password) }

      it { is_expected.to validate_presence_of(:password_confirmation) }
    end

    context 'uniqueness' do
      subject { Fabricate(:user) }

      it { is_expected.to validate_uniqueness_of(:username) }
    end

    context 'confirmation' do
      it { is_expected.to validate_confirmation_of(:password).with_message(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')) }
    end

    context 'has secure password' do
      it { is_expected.to have_secure_password }
    end

    context 'length' do
      it { is_expected.to validate_length_of(:password) }
    end
  end
end
