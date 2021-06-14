class AddAuthorOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :authors_events, :order, :integer
    rename_table :authors_events, :author_events
  end
end
