class AddResultToKeyword < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE TYPE keyword_status AS ENUM ('processing', 'processed', 'error');
    SQL
    
    add_column :keywords, :status, :keyword_status, default: 'processing'
    add_column :keywords, :top_pos_adwords, :int
    add_column :keywords, :non_adwords, :int
    add_column :keywords, :links, :int
    add_column :keywords, :html_code, :text
  end
end
