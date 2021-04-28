class CreateWorkshops < ActiveRecord::Migration[6.1]
  def change
    create_table :workshops do |t|
      t.string :name
      t.text :description
      t.string :zoom_link
      t.datetime :time

      t.timestamps
    end
  end
end
