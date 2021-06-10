class RenameSessions < ActiveRecord::Migration[6.1]
  def change
    rename_table :sessions, :conference_sessions
    remove_reference :events, :session, index: true
    add_reference :events, :conference_session, index: true
    rename_column :conference_sessions, :type, :session_type
  end
end
