class JoinEventsAuthors < ActiveRecord::Migration[6.1]
  def change
    create_join_table :events, :authors, column_options: { null: true }
  end
end
