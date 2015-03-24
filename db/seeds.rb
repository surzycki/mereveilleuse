#encoding: utf-8
require 'csv'


file = File.open('doctor_import.csv', 'rb')
contents    = file.read
sector      = Array.new
professions = Array.new

datas = CSV.parse contents

datas[0..10].each do |data|
  
  begin
    if data[0]
      name_array = data[0].split(' ')
      name      = "#{name_array.pop} #{name_array.join(' ')}".force_encoding('utf-8').titleize
    end

    if data[1]
      address = data[1].force_encoding('utf-8').titleize
    end

    if data[2]
      phone = data[2].delete(' ')
    end

    if data[3]
      mobile = data[3].delete(' ')
    end

    if data[4]
      email = data[4]
    end

  
    if data[5]
      insurance_name = data[5].force_encoding('utf-8').titleize
      insurance = Insurance.find_by(name: insurance_name) || Insurance.create(name: insurance_name)
    
    end

    if data[6]
      profession_name = data[6].force_encoding('utf-8').titleize
      profession = Profession.find_by(name: profession_name) || Profession.create(name: profession_name)
    end

    practitioner = Practitioner.create({
      fullname:     name,
      email:        email, 
      mobile_phone: mobile,
      phone:        phone
    })


    practitioner.insurances << insurance
    practitioner.add_occupation profession.id

    practitioner.location = Location.new({unparsed_address: address})

    practitioner.indexed!
    practitioner.save

  rescue => e
    puts "#{e.message} not found for: #{data[0]}"
  end
end

puts '-- creating admin user...'
AdminUser.create!(email: 'ops@mereveilleuse.com', password: 'thinkbigger', password_confirmation: 'thinkbigger')


#sector.uniq.each do |x|
#  puts x
#end
#
#puts '----'
#
#professions.uniq.each do |x|
#  puts x
#end
#
#puts professions.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
#puts sector.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }#