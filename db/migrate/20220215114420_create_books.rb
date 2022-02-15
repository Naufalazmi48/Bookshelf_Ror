class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :book_id
      t.string :name
      t.integer :year
      t.string :author
      t.text :summary
      t.string :publisher
      t.integer :page_count
      t.integer :read_page
      t.boolean :finished
      t.boolean :reading

      t.timestamps
    end
  end
end
