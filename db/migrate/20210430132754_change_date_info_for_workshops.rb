class ChangeDateInfoForWorkshops < ActiveRecord::Migration[6.1]
  def change
    remove_column :workshops, :date
    add_column :workshops, :date, :integer
  end
end
