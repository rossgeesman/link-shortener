class AddActiveToShortLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :short_links, :active, :boolean, default: true
  end
end
