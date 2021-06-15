class AddZoomToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :zoom_link, :string
  end
end
