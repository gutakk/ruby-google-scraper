class AddResultToKeyword < ActiveRecord::Migration[6.0]
  def change
    add_column :keywords, :status, :string, default: 'processing'
    add_column :keywords, :top_pos_adwords, :int
    add_column :keywords, :adwords, :int
    add_column :keywords, :non_adwords, :int
    add_column :keywords, :links, :int
    add_column :keywords, :html_code, :text
  end
end
