class ChangeTagsStringToText < ActiveRecord::Migration[6.1]
  def change
    change_column :workshops, :tags, :text, array:true, default: []
  end
end
