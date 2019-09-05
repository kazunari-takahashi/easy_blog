class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false, limit: 1000
      t.text :body, null: false
      t.boolean :draft, null: false

      t.timestamps
    end
  end
end
