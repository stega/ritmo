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
end