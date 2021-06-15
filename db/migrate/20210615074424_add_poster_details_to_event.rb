class AddPosterDetailsToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :poster_session, :string
    add_column :events, :poster_order, :integer
  end
end
