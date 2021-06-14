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
    Event.delete_all
    CSV.foreach("ritmo_data/talk_details.csv", {:col_sep => ";"}) do |row|
      next if row[2].blank? || row[2] == 'Session name'

      event = Event.new
      event.title = row[5]
      event.easy_chair = row[1]
      event.title = row[5]
      event.abstract = row[7]
      session = ConferenceSession.find_by(name: row[2])
      puts "cant find session #{row[2]}" if session.nil?
      event.conference_session = session

      row[6].split("\n").each do |kw|
        event.keywords << kw
      end

      event.save!

      # add authors to event
      as = row[4]
      as.gsub!(' and ', ', ')
      as.split(', ').each do |a|
        author = Author.find_by name: a
        if !author.nil?
          event.authors << author
        end
      end
    end
  end

  desc "Import session data"
  task :sessions => :environment do
    require 'csv'
    ConferenceSession.delete_all

    # *********************
    # DAY 1
    # *********************
    ConferenceSession.create(
      name:         "Entrainment (E1)",
      chair:        "Jessica Grahn",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-22 16:00'),
      end:          Time.zone.parse('2021-06-22 17:00'))
    ConferenceSession.create(
      name:         "SMS (S1)",
      chair:        "Caroline Palmer",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-22 17:15'),
      end:          Time.zone.parse('2021-06-22 18:15'))
    ConferenceSession.create(
      name:         "Keynote",
      chair:        "",
      session_type: "Keynote",
      start:        Time.zone.parse('2021-06-22 18:30'),
      end:          Time.zone.parse('2021-06-22 19:30'))
    ConferenceSession.create(
      name:         "Poster blitz",
      chair:        "",
      session_type: "PosterBlitz",
      start:        Time.zone.parse('2021-06-22 19:45'),
      end:          Time.zone.parse('2021-06-22 20:00'))
    ConferenceSession.create(
      name:         "Posters 1",
      chair:        "",
      session_type: "Posters",
      start:        Time.zone.parse('2021-06-22 20:00'),
      end:          Time.zone.parse('2021-06-22 20:45'))
    ConferenceSession.create(
      name:         "SMS (S2)",
      chair:        "Justin London",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-22 21:00'),
      end:          Time.zone.parse('2021-06-22 22:00'))
    ConferenceSession.create(
      name:         "Concert",
      chair:        "",
      session_type: "Concert",
      start:        Time.zone.parse('2021-06-22 21:40'),
      end:          Time.zone.parse('2021-06-22 22:00'))
    ConferenceSession.create(
      name:         "Zoom social",
      chair:        "",
      session_type: "Social",
      start:        Time.zone.parse('2021-06-22 22:00'),
      end:          Time.zone.parse('2021-06-22 22:15'))

    # *********************
    # DAY 2
    # *********************
    ConferenceSession.create(
      name:         "SMS (S3)",
      chair:        "Ed Large",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-23 16:00'),
      end:          Time.zone.parse('2021-06-23 17:00'))
    ConferenceSession.create(
      name:         "Entrainment (E2)",
      chair:        "Benjamin Morillon",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-23 17:15'),
      end:          Time.zone.parse('2021-06-23 18:15'))
    ConferenceSession.create(
      name:         "Music (M1)",
      chair:        "Olivier Senn",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-23 18:30'),
      end:          Time.zone.parse('2021-06-23 19:30'))
    ConferenceSession.create(
      name:         "Poster blitz",
      chair:        "",
      session_type: "PosterBlitz",
      start:        Time.zone.parse('2021-06-23 19:45'),
      end:          Time.zone.parse('2021-06-23 20:00'))
    ConferenceSession.create(
      name:         "Posters 2",
      chair:        "",
      session_type: "Posters",
      start:        Time.zone.parse('2021-06-23 20:00'),
      end:          Time.zone.parse('2021-06-23 20:45'))
    ConferenceSession.create(
      name:         "Entrainment Symposium (E3)",
      chair:        "Hugo Merchant",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-23 21:00'),
      end:          Time.zone.parse('2021-06-23 22:00'))
    ConferenceSession.create(
      name:         "Zoom social",
      chair:        "",
      session_type: "Social",
      start:        Time.zone.parse('2021-06-23 22:00'),
      end:          Time.zone.parse('2021-06-23 22:15'))

    # *********************
    # DAY 3
    # *********************
    ConferenceSession.create(
      name:         "Entrainment (E4)",
      chair:        "Bruno Laeng",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-24 16:00'),
      end:          Time.zone.parse('2021-06-24 17:00'))
    ConferenceSession.create(
      name:         "Music (M2)",
      chair:        "Laura Bishop",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-24 17:15'),
      end:          Time.zone.parse('2021-06-24 18:15'))
    ConferenceSession.create(
      name:         "Speech (SP)",
      chair:        "Molly Henry",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-24 18:30'),
      end:          Time.zone.parse('2021-06-24 19:30'))
    ConferenceSession.create(
      name:         "Poster blitz",
      chair:        "",
      session_type: "PosterBlitz",
      start:        Time.zone.parse('2021-06-24 19:45'),
      end:          Time.zone.parse('2021-06-24 20:00'))
    ConferenceSession.create(
      name:         "Posters 3",
      chair:        "",
      session_type: "Posters",
      start:        Time.zone.parse('2021-06-24 20:00'),
      end:          Time.zone.parse('2021-06-24 20:45'))
    ConferenceSession.create(
      name:         "SMS (S4)",
      chair:        "Marc Leman",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-24 21:00'),
      end:          Time.zone.parse('2021-06-24 22:00'))
    ConferenceSession.create(
      name:         "Concert (Network Performance)",
      chair:        "",
      session_type: "Concert",
      start:        Time.zone.parse('2021-06-24 21:40'),
      end:          Time.zone.parse('2021-06-24 22:00'))
    ConferenceSession.create(
      name:         "Zoom social",
      chair:        "",
      session_type: "Social",
      start:        Time.zone.parse('2021-06-24 22:00'),
      end:          Time.zone.parse('2021-06-24 22:15'))

    # *********************
    # DAY 3
    # *********************
    ConferenceSession.create(
      name:         "Keynote",
      chair:        "",
      session_type: "Keynote",
      start:        Time.zone.parse('2021-06-25 16:00'),
      end:          Time.zone.parse('2021-06-25 17:00'))
    ConferenceSession.create(
      name:         "Medical (Med)",
      chair:        "Laurel Trainor",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-25 17:15'),
      end:          Time.zone.parse('2021-06-25 18:15'))
    ConferenceSession.create(
      name:         "Entrainment (E5)",
      chair:        "Daniel Cameron",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-25 18:30'),
      end:          Time.zone.parse('2021-06-25 19:30'))
    ConferenceSession.create(
      name:         "Poster blitz",
      chair:        "",
      session_type: "PosterBlitz",
      start:        Time.zone.parse('2021-06-25 19:45'),
      end:          Time.zone.parse('2021-06-25 20:00'))
    ConferenceSession.create(
      name:         "Posters 4",
      chair:        "",
      session_type: "Posters",
      start:        Time.zone.parse('2021-06-25 20:00'),
      end:          Time.zone.parse('2021-06-25 20:45'))
    ConferenceSession.create(
      name:         "Music (M3)",
      chair:        "Lauren Fink",
      session_type: "Talks",
      start:        Time.zone.parse('2021-06-25 21:00'),
      end:          Time.zone.parse('2021-06-25 22:00'))
    ConferenceSession.create(
      name:         "Concert (Scandinavian fiddle music by Anne Hytta)",
      chair:        "",
      session_type: "Concert",
      start:        Time.zone.parse('2021-06-25 21:40'),
      end:          Time.zone.parse('2021-06-25 22:00'))
  end

end