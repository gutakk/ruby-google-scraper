# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleScrapingJob, type: :job do
  include ActiveJob::TestHelper
  ActiveJob::Base.queue_adapter = :test

  describe '#perform' do
    context 'given valid keyword (with top position adwords)' do
      it 'enqueues google scraping job' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        expect do
          GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
        end.to have_enqueued_job(GoogleScrapingJob)

        assert_enqueued_with(job: GoogleScrapingJob, args: [keyword.id, 'AWS'])
      end
    end
  end
end
