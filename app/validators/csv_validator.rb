# frozen_string_literal: true

require 'csv'

class CsvValidator < ActiveModel::Validator
  def validate(record)
    file = record.instance_variable_get(:@file)

    return record.errors.add(:base, I18n.t('keyword.file_must_be_csv')) unless file.content_type == 'text/csv'
    return record.errors.add(:base, I18n.t('keyword.keyword_range')) unless CSV.read(file).count.between?(1, 1000)
  end
end
