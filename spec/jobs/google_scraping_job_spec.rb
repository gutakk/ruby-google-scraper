# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleScrapingJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'enqueues google scraping job' do
      user = Fabricate(:user)
      keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

      expect do
        GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
      end.to have_enqueued_job(GoogleScrapingJob)

      assert_enqueued_with(job: GoogleScrapingJob, args: [keyword.id, 'AWS'])
    end

    context 'given error raising' do
      it 'retrys the job 5 times' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'AWS')

        allow_any_instance_of(GoogleScrapingJob).to receive(:perform).and_raise(Timeout::Error)

        assert_performed_jobs 5 do
          GoogleScrapingJob.perform_later(keyword.id, keyword.keyword)
        end
      end
    end
  end
end
