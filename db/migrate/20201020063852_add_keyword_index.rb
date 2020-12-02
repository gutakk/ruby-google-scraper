class AddKeywordIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :keywords, :keyword
  end
end
