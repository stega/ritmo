class AddTagsToWorkshops < ActiveRecord::Migration[6.1]
  def change
    add_column :workshops, :tags, :string
  end
end
