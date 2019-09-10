class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :boxy
      t.boolean :draft

      t.timestamps
    end
  end
end
