class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews, id: :uuid do |t|
      t.references :book, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :rating
      t.text :content

      t.timestamps
    end
  end
end
