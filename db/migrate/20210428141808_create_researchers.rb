class CreateResearchers < ActiveRecord::Migration[6.1]
  def change
    create_table :researchers do |t|
      t.string :name

      t.timestamps
    end
  end
end
