# frozen_string_literal: true

require 'csv'

class CsvImportForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes

  attribute :user
  attribute :file

  validates_with CsvValidator

  def initialize(attributes = {})
    super(attributes)
  end

  def save(attributes)
    assign_attributes(attributes)

    return self unless valid?

    bulk_data = []

    CSV.foreach(file.path) do |row|
      bulk_data << { user_id: user.id, keyword: row[0], created_at: Time.current, updated_at: Time.current }
    end

    # rubocop:disable Rails/SkipsModelValidations
    Keyword.insert_all(bulk_data, returning: %w[id keyword])
    # rubocop:enable Rails/SkipsModelValidations
  end
end
