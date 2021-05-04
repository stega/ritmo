class RenameTypeToSessionTypeWorkshops < ActiveRecord::Migration[6.1]
  def change
    rename_column :workshops, :type, :session_type
  end
end
