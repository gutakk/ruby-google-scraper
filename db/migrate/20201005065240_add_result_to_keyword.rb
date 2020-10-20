class AddResultToKeyword < ActiveRecord::Migration[6.0]
  def change
    add_column :keywords, :status, :integer, default: 0
    add_column :keywords, :top_pos_adwords, :int
    add_column :keywords, :adwords, :int
    add_column :keywords, :non_adwords, :int
    add_column :keywords, :links, :int
    add_column :keywords, :html_code, :text
    add_column :keywords, :top_pos_adword_links, :json
    add_column :keywords, :non_adword_links, :json
    add_column :keywords, :failed_reason, :text
  end
end
