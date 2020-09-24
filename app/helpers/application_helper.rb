# frozen_string_literal: true

module ApplicationHelper
  def page_title
    return [t('app.title'), (content_for :title_suffix)].join(' | ') if (content_for :title_suffix).present?

    t('app.title')
  end
end
