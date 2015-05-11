# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

USER_COUNT         = 10
PRACTITIONER_COUNT = 50

PatientType.delete_all
Profession.delete_all
User.delete_all
Practitioner.delete_all

puts '-- creating patient types...'
patient_types = PatientType.create([
  { name: 'Une future maman'},
  { name: 'Une maman'},
  { name: 'Un nourisson (0 - 3)'},
  { name: 'Un enfant (4 - 11)'},
  { name: 'Un adolescent (12 ans +)'}
])

puts '-- creating professions...'
professions = Profession.create([
  { name: 'Médecin Généralist' },
  { name: 'Nutritionniste' },
  { name: 'Ostéopathes' },
  { name: 'Pédiatres' },
  { name: 'Sophrologues' }
])

puts '-- creating generic users...'
users = Array.new(USER_COUNT) {
  user = User.create()
  user.facebook_id  = rand.to_s[2..11]
  user.firstname    = Forgery(:name).first_name
  user.lastname     = Forgery(:name).last_name
  user.email        = Forgery(:internet).email_address
  user.location     = Location.new( street: Forgery(:address).street_address, city: Forgery(:address).city, postal_code: Forgery(:address).zip, country: Forgery(:address).country)
  user.save
}

puts '-- creating indexed practitioners...'
practitioners = Array.new(PRACTITIONER_COUNT) {
  practitioner = Practitioner.create()
  practitioner.firstname    = Forgery(:name).first_name
  practitioner.lastname     = Forgery(:name).last_name
  practitioner.email        = Forgery(:internet).email_address
  practitioner.phone        = Forgery(:address).phone
  practitioner.mobile_phone = Forgery(:address).phone
  practitioner.location     = Location.new( street: Forgery(:address).street_address, city: Forgery(:address).city, postal_code: Forgery(:address).zip, country: Forgery(:address).country)
  practitioner.occupations  << Occupation.create( { profession: Profession.all.sample, experience: 10 } )

  practitioner.indexed!
  practitioner.save
}

puts '-- creating admin user...'
AdminUser.create!(email: 'ops@mereveilleuse.com', password: 'thinkbigger', password_confirmation: 'thinkbigger')

puts '-- indexing'
Practitioner.reindex
