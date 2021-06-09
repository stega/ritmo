class UpdateWorkshops < ActiveRecord::Migration[6.1]
  def change
    remove_reference :workshops, :researcher, index: true
    add_reference :workshops, :author
  end
end
