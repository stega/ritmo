class LinkResearchersToWorkshops < ActiveRecord::Migration[6.1]
  def change
    add_reference :workshops, :researcher
  end
end
