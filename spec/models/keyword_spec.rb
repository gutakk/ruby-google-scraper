# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'association' do
    context 'has many' do
      it { is_expected.to have_many(:adword_links) }
    end

    context 'has many' do
      it { is_expected.to have_many(:non_adword_links) }
    end

    context 'belong to' do
      it { is_expected.to belong_to(:user) }
    end
  end
end
