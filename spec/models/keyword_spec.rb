# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'association' do
    context 'belong to' do
      it { is_expected.to belong_to(:user) }
    end
  end

  describe 'enum' do
    it { is_expected.to define_enum_for(:status) }
  end
end
