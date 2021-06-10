class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :name
      t.string :chair
      t.string :type
      t.datetime :start
      t.datetime :end
      t.timestamps
    end
  end
end
