class CreateAdwordLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :top_position_adword_links do |t|
      t.belongs_to :keyword, foreign_key: true

      t.string :link

      t.timestamps
    end
  end
end
