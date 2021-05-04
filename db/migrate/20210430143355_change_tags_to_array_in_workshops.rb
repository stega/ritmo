class ChangeTagsToArrayInWorkshops < ActiveRecord::Migration[6.1]
  def change
    remove_column :workshops, :tags, :string
    add_column :workshops, :tags, :string, array:true, default: []
    remove_column :workshops, :duration, :integer
    add_column :workshops, :duration, :string
  end
end
