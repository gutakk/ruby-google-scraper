# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NonAdwordLink, type: :model do
  describe 'association' do
    context 'belong to' do
      it { is_expected.to belong_to(:keyword) }
    end
  end
end
