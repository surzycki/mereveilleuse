json.array! @results do |result|
  json.id               SecureRandom.hex
  json.fullname         result.fullname
  json.address          result.address
  json.profession_name  result.primary_occupation.name
end

