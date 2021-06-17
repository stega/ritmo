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
    Rake::Task["import:social"].invoke
    Rake::Task["import:concerts"].invoke
  end

  desc "Import author data"
  task :authors => :environment do
    require 'csv'
    Author.delete_all
    CSV.foreach("ritmo_data/authors.csv", {:col_sep => ";"}) do |row|
      if Author.find_by(name: "#{row[1]} #{row[2]}")
        a = Author.find_by(name: "#{row[1]} #{row[2]}")
        a.update(country: row[5]) if !row[5].blank?
        a.update(webpage: row[6]) if !row[6].blank?
      else
        a = Author.new
        a.name        = "#{row[1]} #{row[2]}"
        a.email       = row[3]
        a.affiliation = row[4]
        a.country     = row[5]
        a.webpage     = row[6]
        a.save
      end
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
      event.zoom_link    = "FIXED ZOOM LINK"
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
      event.zoom_link    = row[9]&.strip
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

  desc "Import concert data"
  task :concerts => :environment do
    Event.where(event_type: 'concert').delete_all
    event_ids = Event.where(event_type: 'concert').pluck(:id)
    AuthorEvent.where('event_id IN (?)', event_ids).delete_all

    # CONCERT 1
    event              = Event.new
    event.title        = "Fibres Out of Line"
    event.abstract     = "Fibres Out of Line is an interactive art installation and performance for the 2021 Rhythm Perception and Production Workshop (RPPW). Visitors can watch the performance, and subsequently interact with the installation, all remotely via Zoom."
    event.youtube_link = "https://michaelkrzyzaniak.com/Fibers_Out_Of_Line/"
    event.zoom_link    = "https://uio.zoom.us/s/61075841243"
    event.event_type   = "concert"
    event.conference_session = ConferenceSession.find_by(name: "Concert 1")
    event.save!

    # CONCERT 2
    event              = Event.new
    event.title        = "N-place: telematic études for physically distant networked music performance"
    event.abstract     = "N-place is a platform for telematic embodied music performance in a shared distributed acoustic space. Three geographically distant spaces are brought closer by means of network technologies, motion capture, and spatial audio. The movements of musicians in Berlin, Oslo, and Stockholm are tracked live, as they perform together via the low-latency audio connection. Their movement in space is used to render and ambisonics 360° sound stage that places the sound of each musician in a shared sound stage. This will be experienced by the musicians as well as by the audience attending the live stream, as the spatial sound will be encoded in a binaural rendering suitable for stereo headphones. N-place is developed in an effort of creating a shared distributed place where musicians and audiences can experience live music from multiple remote locations."
    event.youtube_link = ""
    event.event_type   = "concert"
    event.conference_session = ConferenceSession.find_by(name: "Concert 2")
    event.save!

    # CONCERT 3
    event              = Event.new
    event.title        = "Scandinavian fiddle music"
    event.abstract     = "Norwegian musician and composer Anne Hytta is a performer of the traditional music of Telemark on Hardanger fiddle, and of her own new composed and improvised music. The Hardanger fiddle has sympathetic strings and its own repertoire of traditional tunes. Her background is deeply founded in the highly distinctive playing style of the repertoire of traditional tunes for the Hardanger fiddle, and from this basis, she composes and performs her own music. She has created her own solo performance Draumsyn and Gjennom dagen consisting of new compositions for Hardanger fiddle, viola d’amore and medieval vielle. The music was released on the German label Carpe Diem in January 2014 to great reviews both in Norwegian and foreign press. In 2006, 2007 and 2009 Anne Hytta received the Norwegian Government Grants for younger artists. She received the Norwegian Folk Music Award for a best solo album in 2006, 2011 and 2017, and the Norwegian Grammy (Spellemannprisen) in the open category in 2015 for Slagr album “Short stories” and in the category of traditional music in 2017 for the solo album “Strimur”."
    event.youtube_link = ""
    event.event_type   = "concert"
    event.conference_session = ConferenceSession.find_by(name: "Concert 3")
    event.save!
    a = Author.new
    a.name = "Anne Hytta"
    a.country = "Anne Hytta is a performer of the hardanger fiddle. She composes and performs her own music in her solo production Draumsyn"
    a.webpage = "http://www.annehytta.com"
    a.save!
    event.authors << a
  end

  desc "Import social data"
  task :social => :environment do
    3.times do |num|
      event              = Event.new
      event.title        = "Social event"
      event.event_type   = "social"
      event.zoom_link    = "https://uio.zoom.us/j/64601680538?pwd=djFIRWhuNHBORXcrQjk1bXo2UUg1UT09"
      event.conference_session = ConferenceSession.where(name: 'Zoom social')[num]
      event.save!
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
    event.zoom_link    = "FIXED ZOOM LINK"
    event.save!

    event = Event.new
    event.event_type = 'keynote'
    event.title = "Mapping between sound, brain and behavior for understanding musical meter"
    event.abstract = "All over the world, music powerfully compels people to move the body in time with the musical rhythm. Importantly, in many music and dance scenarios, individuals spontaneously coordinate periodic body movement even when the rhythm does not contain prominent periodic onsets that cue accurate movement synchronization. This behavior illustrates the ability of humans to coordinate body movement in time with acoustic rhythms with great flexibility compared to other animal species. How is that made possible? When listening to musical rhythm, humans perceive one or several levels of periodic pulses (a meter, for short). These internally represented metric pulses can then be used as a temporal reference for movement coordination. \n One way to investigate the neural bases of this rhythmic behavior is electroencephalography (EEG) combined with frequency-tagging. This approach has been developed over the past ten years with the input of a number of researchers, and offers a measure of how rhythmic inputs are mapped onto neural activity and body movement. I will present recent experiments conducted in healthy and brain-damaged adults, and also in infants, while exposed to rhythms as diverse as repeated rhythmic patterns or naturalistic music. Results show that neural populations respond to the rhythmic input by systematically amplifying specific subsets of frequencies, thus yielding some sort of \"periodization\" of the input. This neural enhancement seems to correlate with perception and individual ability to move in time with musical rhythm, and cannot be explained by acoustic features or low-level auditory subcortical processing of the rhythmic input.  Based on these different results, I propose a four-level framework to exploring the neural bases of this rhythmic behavior across individuals, in evolutionary terms and over development."
    event.authors << Author.find_by(name: "Sylvie Nozaradan")
    event.conference_session = ConferenceSession.find_by(name: 'Keynote 2')
    event.zoom_link    = "FIXED ZOOM LINK"
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
      name:         "Concert 1",
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
      name:         "Concert 2",
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
      name:         "Concert 3",
      chair:        "",
      session_type: "Concert",
      start:        Time.zone.parse('2021-06-25 21:40'),
      end:          Time.zone.parse('2021-06-25 22:00'))
  end

end