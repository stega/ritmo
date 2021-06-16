namespace :import do
  desc "Import everything"
  task :all => :environment do
    Event.delete_all
    AuthorEvent.delete_all
    Rake::Task["import:authors"].invoke
    Rake::Task["import:sessions"].invoke
    Rake::Task["import:talks"].invoke
    Rake::Task["import:posters"].invoke
    Rake::Task["import:keynotes"].invoke
  end

  desc "Import author data"
  task :authors => :environment do
    require 'csv'
    Author.delete_all
    CSV.foreach("ritmo_data/authors.csv", {:col_sep => ";"}) do |row|
      next if Author.find_by(email: row[3])
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
    Event.where(event_type: 'talk').delete_all
    event_ids = Event.where(event_type: 'talk').pluck(:id)
    AuthorEvent.where('event_id IN (?)', event_ids).delete_all

    CSV.foreach("ritmo_data/talks.csv", {:col_sep => ";"}) do |row|
      next if row[2].blank? || row[2] == 'Session name'

      event              = Event.new
      event.title        = row[5].strip
      event.easy_chair   = row[1].strip
      event.abstract     = row[7].strip
      event.youtube_link = row[8]&.strip
      event.vortex_link  = row[9]&.strip
      event.event_type   = "talk"
      session = ConferenceSession.find_by(name: row[2].strip)
      puts "cant find session #{row[2]}" if session.nil?
      event.conference_session = session

      row[6].split("\n").each do |kw|
        event.keywords << kw
      end

      event.save!

      # add authors to event
      as = row[4]
      as.gsub!(' and ', ', ')
      order_num = 1
      as.split(', ').each do |a|
        author = Author.find_by name: a
        if !author.nil?
          ae = AuthorEvent.new
          ae.author_id = author.id
          ae.event_id = event.id
          ae.order = order_num
          ae.save
          order_num += 1
        end
      end
    end
  end

  desc "Import poster data"
  task :posters => :environment do
    require 'csv'
    Event.where(event_type: 'poster').delete_all
    event_ids = Event.where(event_type: 'poster').pluck(:id)
    AuthorEvent.where('event_id IN (?)', event_ids).delete_all

    CSV.foreach("ritmo_data/posters.csv", {:col_sep => ";"}) do |row|
      next if row[1].blank? || row[1] == 'Poster Session'

      event              = Event.new
      event.title        = row[4]
      event.easy_chair   = row[0]
      event.abstract     = row[6]
      event.youtube_link = row[7]
      event.vortex_link  = row[8]
      event.event_type   = "poster"
      event.poster_order = row[2]
      session = ConferenceSession.find_by(name: "Posters #{row[1].strip}")
      puts "cant find session Posters #{row[1]}" if session.nil?
      event.conference_session = session

      row[5].split("\n").each do |kw|
        event.keywords << kw
      end

      event.save!

      # add authors to event
      as = row[3]
      as.gsub!(' and ', ', ')
      order_num = 1
      as.split(', ').each do |a|
        author = Author.find_by name: a
        if !author.nil?
          ae = AuthorEvent.new
          ae.author_id = author.id
          ae.event_id = event.id
          ae.order = order_num
          ae.save
          order_num += 1
        end
      end
    end
  end

  desc "Import keynote data"
  task :keynotes => :environment do
    Event.where(event_type: 'keynote').delete_all
    event_ids = Event.where(event_type: 'keynote').pluck(:id)
    AuthorEvent.where('event_id IN (?)', event_ids).delete_all

    event = Event.new
    event.event_type = 'keynote'
    event.title = "In the wake of Henry Shaffer: approaches, events, togetherness"
    event.abstract = "This keynote pays tribute to the work of Henry Shaffer (1929-2020), who attended RPPW1 in Cambridge in 1984 (and was characteristically dismissive of it!), and whose work made pioneering contributions to the detailed study of timing in musical performance. These included a commitment to complex rhythmic behaviours, the study of those behaviours in realistic circumstances, the development of a unique technology to make that research possible, and rigorous but unconventional methods. I reflect on some of those contributions and the impact that they have had on the field, and consider some of the ways in which research has moved on or away from the approach that Henry’s research represented. In particular I pick up on what Henry always called rubato but which is now more commonly called microtiming and consider again the relationship between continuously variable and categorical values; motor programming and its alternatives; and finally some recent work on timing and togetherness in large ensemble performance, and arguments for the historicity of the concept of ‘togetherness’."
    event.authors << Author.find_or_create_by(name: "Eric F. Clarke")
    event.conference_session = ConferenceSession.find_by(name: 'Keynote 1')
    event.save!

    event = Event.new
    event.event_type = 'keynote'
    event.title = "Mapping between sound, brain and behavior for understanding musical meter"
    event.abstract = "All over the world, music powerfully compels people to move the body in time with the musical rhythm. Importantly, in many music and dance scenarios, individuals spontaneously coordinate periodic body movement even when the rhythm does not contain prominent periodic onsets that cue accurate movement synchronization. This behavior illustrates the ability of humans to coordinate body movement in time with acoustic rhythms with great flexibility compared to other animal species. How is that made possible? When listening to musical rhythm, humans perceive one or several levels of periodic pulses (a meter, for short). These internally represented metric pulses can then be used as a temporal reference for movement coordination. \n One way to investigate the neural bases of this rhythmic behavior is electroencephalography (EEG) combined with frequency-tagging. This approach has been developed over the past ten years with the input of a number of researchers, and offers a measure of how rhythmic inputs are mapped onto neural activity and body movement. I will present recent experiments conducted in healthy and brain-damaged adults, and also in infants, while exposed to rhythms as diverse as repeated rhythmic patterns or naturalistic music. Results show that neural populations respond to the rhythmic input by systematically amplifying specific subsets of frequencies, thus yielding some sort of \"periodization\" of the input. This neural enhancement seems to correlate with perception and individual ability to move in time with musical rhythm, and cannot be explained by acoustic features or low-level auditory subcortical processing of the rhythmic input.  Based on these different results, I propose a four-level framework to exploring the neural bases of this rhythmic behavior across individuals, in evolutionary terms and over development."
    event.authors << Author.find_by(name: "Sylvie Nozaradan")
    event.conference_session = ConferenceSession.find_by(name: 'Keynote 2')
    event.save!
  end

  desc "Import session data"
  task :sessions => :environment do
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
      name:         "Keynote 1",
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
      name:         "Keynote 2",
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