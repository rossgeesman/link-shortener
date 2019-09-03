class CreateShortLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :short_links do |t|
      t.string :original_url, null: false
      t.string :admin_secret, null: false
      t.integer :view_count, default: 0, null: false
      t.timestamps
    end
    add_index :short_links, :admin_secret, unique: true
  end
end
