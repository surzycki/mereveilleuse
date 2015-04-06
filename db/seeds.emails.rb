#encoding: utf-8
require 'csv'
require 'unicode_utils'

puts '-- import emails database...'
file_contents = CSV.read("spec/fixtures/emails.csv", col_sep: ",")

decoded = file_contents.map do |line|
  line.map do |entry|
    if entry
      UnicodeUtils.compatibility_decomposition(entry)
    else
      ''
    end
  end
end

decoded.each do |data|
  begin
    if data[1].present?
      address = data[1].squish.titleize
    end

    location = Location.find_by(unparsed_address: address)
    if location
      practitioner = location.locatable
    end

    if data[2].present?
      email = data[2]
    end

    if practitioner
      practitioner.email = email
      practitioner.save

      puts '---------------'
      puts practitioner.fullname
      puts email
    else
      puts '==============='
      puts 'NOT FOUND'
      puts "#{data[0]}"
      puts "#{address}"
      puts "#{email}"
    end
  rescue => e
    puts "#{e.message} not found for: #{data[0]}"
  end
end
