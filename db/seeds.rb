#encoding: utf-8
require 'csv'
require 'unicode_utils'

puts '-- import psychomotricien database...'
file_contents = CSV.read("spec/fixtures/yoga.csv", col_sep: ",")

decoded = file_contents.map do |line|
  line.map do |entry|
    if entry
      UnicodeUtils.compatibility_decomposition(entry)
    else
      ''
    end
  end
end

practitioner_last = nil

decoded.each do |data|
  begin
    
  rescue => e
    puts "#{e.message} not found for: #{data[0]}"
  end
end

Practitioner.reindex
Profession.reindex

#AdminUser.create!(email: 'ops@mereveilleuse.com', password: 'thinkbigger', password_confirmation: 'thinkbigger')