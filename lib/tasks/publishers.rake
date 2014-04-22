namespace :publishers do

  desc "Imports Publishers to Deals App"
  task :import, [:publisher_name, :file_name] => [:environment] do |t, args|
    tmp_dir = "#{Rails.root}/script/data/"

    puts "### Importing Publisher: #{args[:publisher_name]} ###"

    # create a Publisher with the name received in the arguments and instantiate the file
    publisher = Publisher.find_or_create_by_name(args[:publisher_name], theme: "entertainment")
    file      = File.new(tmp_dir + args[:file_name])

    # iterate each line from the second row
    file.drop(1).each do |row|
      scanner = StringScanner.new(row)

      # Create of look for an existing advertiser given a name
      advertiser = publisher.advertisers.find_or_create_by_name(scanner.scan(/\D+/))

      # Creates the deal with the rest of the data
      advertiser.deals.where(
        start_at: scanner.scan(/\d{1,2}\/\d{1,2}\/\d{2,4}\s*/),
        end_at: scanner.scan(/\d{1,2}\/\d{1,2}\/\d{2,4}\s*/),
        description: scanner.scan(/\D+/),
        price: scanner.scan(/\d+\s*/),
        value: scanner.scan(/\d+\s*/)
      ).first_or_create
    end
  end


end

