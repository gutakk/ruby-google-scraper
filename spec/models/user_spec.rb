# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation test', :aggregate_failures do
    it 'username presence' do
      user = User.new(password: 'password', password_confirmation: 'password').save
      expect(user).to eq(false)
    end

    it 'password presence' do
      user = User.new(username: 'nimblehq', password_confirmation: 'password').save
      expect(user).to eq(false)
    end

    it 'password confirmation presence' do
      user = User.new(username: 'nimblehq', password: 'password').save
      expect(user).to eq(false)
    end

    it 'password and password confirmation don\'t match' do
      user = User.new(username: 'nimblehq', password: 'password', password_confirmation: 'password1').save
      expect(user).to eq(false)
    end

    it 'username uniqueness' do
      user1 = User.new(username: 'nimblehq', password: 'password', password_confirmation: 'password').save
      user2 = User.new(username: 'nimblehq', password: 'drowssap', password_confirmation: 'drowssap').save

      expect(user1).to eq(true)
      expect(user2).to eq(false)
    end

    it 'password digest' do
      user = User.new
      assert_respond_to user, :password_digest
    end
  end
end
