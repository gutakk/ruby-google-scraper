class CreateKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :keywords do |t|
      t.belongs_to :user, foreign_key: true

      t.string :keyword

      t.timestamps
    end
  end
end
