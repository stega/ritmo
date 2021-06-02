class RemoveDefaultTimezone < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :time_zone, nil
  end
end
