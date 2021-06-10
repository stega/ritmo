class ChangeWorkshops < ActiveRecord::Migration[6.1]
  def change
    add_column :workshops, :easy_chair, :integer
    add_column :workshops, :vortex_link, :string
    add_reference :workshops, :session, index: true
    rename_column :workshops, :name, :title
    rename_column :workshops, :description, :abstract
    rename_column :workshops, :zoom_link, :youtube_link
    rename_column :workshops, :tags, :keywords
    rename_column :workshops, :session_type, :event_type
    remove_column :workshops, :time_start, :time
    remove_column :workshops, :date, :date
    remove_column :workshops, :duration, :integer
    remove_reference :workshops, :author, index: true
    rename_table :workshops, :events
  end
end
