# encoding: utf-8
require 'csv'


file = File.open('doctor_import.csv', 'rb')
contents = file.read
sector = Array.new
professions = Array.new

datas = CSV.parse contents

datas.each do |data|
  begin
    sector.push data[5]
    professions.push data[6]
  rescue
    puts "not found for: #{data[0]}"
  end
end

sector.uniq.each do |x|
  puts x
end

puts '----'

professions.uniq.each do |x|
  puts x
end