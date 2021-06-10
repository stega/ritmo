namespace :import do
  desc "Import author data"
  task :authors => :environment do
    require 'csv'
    Author.delete_all
    CSV.foreach("ritmo_data/author_details.csv", {:col_sep => ";"}) do |row|
      a = Author.new
      a.name        = "#{row[1]} #{row[2]}"
      a.email       = row[3]
      a.country     = row[4]
      a.affiliation = row[5]
      a.webpage     = row[6]
      a.save
    end
  end

  desc "Import talk data"
  task :talks => :environment do
    require 'csv'
    Workshop.delete_all
    CSV.foreach("ritmo_data/workshop_details.csv", {:col_sep => ";"}) do |row|
      workshop = Workshop.new
      # TODO: whats gonna go into workshop?
      # and are we gonna create a seperate Session object?
        # this could be good. but how to organise?
        # we would then want the programme to include days,
        # and each day to have a list of sessions, and each session
        # to have a list of events.
      # OR:
        # re-do workshops, and create session objects, but arrange
        # them manually/hard-code like i have with days.
        # THIS. can always add programme and days objects later.
      # should we rename Workshop? To what? Event? Happening?
      # are there any differences between Keynote, Talk, Concert, Poster?
      # workshop.name        = "#{row[1]} #{row[2]}"
      # workshop.email       = row[3]
      # workshop.country     = row[4]
      # workshop.affiliation = row[5]
      # workshop.webpage     = row[6]
      # workshop.save
    end
  end

end