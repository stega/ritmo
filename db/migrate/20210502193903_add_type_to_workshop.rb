class AddTypeToWorkshop < ActiveRecord::Migration[6.1]
  def change
    add_column :workshops, :type, :string
  end
end
