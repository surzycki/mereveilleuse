#encoding: utf-8
require 'csv'
require 'unicode_utils'

puts '-- import psychomotricien database...'
file_contents = CSV.read("spec/fixtures/psychomotricien.csv", col_sep: ",")

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
    if data[0].present?
      name_array = data[0].downcase.split(' ')
      # invert name
      name = "#{name_array.pop} #{name_array.join(' ')}".titleize   
    end

    if data[1].present?
      address = data[1].squish.titleize
    end

    if data[2].present?
      phone = data[2].delete(' ')
    end

    if data[3].present?
      mobile = data[3].delete(' ')
    end

    if data[4].present?
      email = data[4]
    end

    profession_name = 'Psychomotricien'
    profession = Profession.find_by(name: profession_name) || Profession.create(name: profession_name)
    profession.indexed!
    profession.save

    practitioner = Practitioner.new({
      fullname:     name,
      mobile_phone: mobile,
      phone:        phone,
      email:        email
    })

    if profession
      practitioner.add_occupation profession.id
    end

    if address
      practitioner.location = Location.new({unparsed_address: address})
    end

    puts '------------------'
    unless practitioner.fullname == practitioner_last.try(:fullname)
      puts practitioner.fullname
      puts profession.name
      puts practitioner.contact_phone
      puts practitioner.email
      puts address
      
      practitioner.indexed!
      practitioner.save
    else
      puts "#{practitioner.fullname} DUPLICATION"
    end

    practitioner_last = practitioner
  rescue => e
    puts "#{e.message} not found for: #{data[0]}"
  end
end

Practitioner.reindex
Profession.reindex

#AdminUser.create!(email: 'ops@mereveilleuse.com', password: 'thinkbigger', password_confirmation: 'thinkbigger')