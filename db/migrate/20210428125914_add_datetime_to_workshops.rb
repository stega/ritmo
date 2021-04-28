class AddDatetimeToWorkshops < ActiveRecord::Migration[6.1]
  def change
    remove_column :workshops, :time
    add_column :workshops, :time_start, :time
    add_column :workshops, :duration, :integer
    add_column :workshops, :date, :date

  end
end
