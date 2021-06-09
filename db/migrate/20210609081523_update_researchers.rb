class UpdateResearchers < ActiveRecord::Migration[6.1]
  def change
    rename_table :researchers, :authors
    add_column :authors, :affiliation, :string
    add_column :authors, :country, :string
    add_column :authors, :webpage, :string
    remove_column :authors, :phone, :string
  end
end
