# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PatientType.delete_all
Profession.delete_all

patient_types = PatientType.create([
  { name: 'Une future maman'},
  { name: 'Une maman'},
  { name: 'Un nourisson (0 - 3)'},
  { name: 'Un bébé (4 - 11)'},
  { name: 'Un adolescent (12 ans +)'}
])

profression = Profession.create([
  { name: 'Médecin Généralist' },
  { name: 'Nutritionniste' },
  { name: 'Ostéopathes' },
  { name: 'Pédiatres' },
  { name: 'Sophrologues' }
])