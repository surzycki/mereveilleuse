#encoding: utf-8
require 'csv'
require 'unicode_utils'


puts '-- import practitioner database...'
file_contents = CSV.read("spec/fixtures/doctor_import.csv", col_sep: ",")

decoded = file_contents.map do |line|
  line.map do |entry|
    if entry
      UnicodeUtils.compatibility_decomposition(entry)
    else
      ''
    end
  end
end

PREFIXES = ['dr','madame','monsieur']

decoded.sample(2000).each do |data|
  begin
    
    if data[0].present?
      # handle DR, Madame, Monsieur
      name_array = data[0].downcase.split(' ')
    
      if (name_array & PREFIXES).empty?
        # invert name
        name = "#{name_array.pop} #{name_array.join(' ')}".titleize   
      else
        # remove dr, madame, mon
        name_array.shift
        name = name_array.join(' ').titleize
      end
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
  
    if data[5].present?
      insurance_name = data[5].titleize
      insurance = Insurance.find_by(name: insurance_name) || Insurance.create(name: insurance_name)
    end

    if data[6].present?
      profession_name = data[6].titleize
      profession = Profession.find_by(name: profession_name) || Profession.create(name: profession_name)
      profession.indexed!
    end

    practitioner = Practitioner.create({
      fullname:     name,
      email:        email, 
      mobile_phone: mobile,
      phone:        phone
    })
    
    if insurance
      practitioner.insurances << insurance
    end

    if profession
      practitioner.add_occupation profession.id
    end

    if address
      practitioner.location = Location.new({unparsed_address: address})
    end

    practitioner.indexed!
    practitioner.save

    puts '-------'
    puts "#{practitioner.fullname}"
    puts practitioner.address

  rescue => e
    puts "#{e.message} not found for: #{data[0]}"
  end
end

puts '-- creating admin user...'
AdminUser.create!(email: 'ops@mereveilleuse.com', password: 'thinkbigger', password_confirmation: 'thinkbigger')

puts '-- creating patient types...'
patient_types = PatientType.create([
  { name: 'Une future maman'},
  { name: 'Une maman'},
  { name: 'Un nourisson (0 - 3)'},
  { name: 'Un bébé (4 - 11)'},
  { name: 'Un adolescent (12 ans +)'}
])



unless Rails.env.production? 
  
  USER_COUNT = 10
  puts '-- creating generic users...'
  users = Array.new(USER_COUNT) {
    user = User.create()
    user.facebook_id   = rand.to_s[2..11]
    user.profile_image = 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/p200x200/11048272_10152899386389495_4816823952488602691_n.jpg?oh=4b6cecd2f0fa443344ac295183b109e6&oe=55A3BDD1&__gda__=1434000297_0c5a7ac3f49cfca954338920bad8178c'
    user.firstname     = Forgery(:name).first_name
    user.lastname      = Forgery(:name).last_name
    user.email         = Forgery(:internet).email_address
    user.location      = Location.new( street: Forgery(:address).street_address, city: Forgery(:address).city, postal_code: Forgery(:address).zip, country: Forgery(:address).country)
    user.verified      = [true,false].sample
    user.friend_count  = rand(0..400)
    user.save
  }

  RECOMMENDATION_COUNT = 200
  puts '-- creating recommendation users...'

  recommendations = Array.new(RECOMMENDATION_COUNT) {
    practitioner = Practitioner.joins(:location).where("unparsed_address LIKE '%Paris'").sample

    form = RecommendationForm.new({
      user_id:            User.all.sample.id,
      practitioner_name:  practitioner.fullname,
      patient_type_id:    PatientType.all.sample.id,
      profession_name:    practitioner.primary_occupation.name,
      address:            practitioner.address,
      wait_time:          rand(0..4),
      availability:       rand(0..4),
      bedside_manner:     rand(0..4),
      efficacy:           rand(0..4),
      comment:            Forgery(:lorem_ipsum).words(rand(5..10))
    })

    form.process

    GeocodePractitionerJob.perform_later practitioner
  }
end

puts '-- indexing models...'
Practitioner.reindex
Recommendation.reindex
Profession.reindex
  