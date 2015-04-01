json.array! @results do |result|
  json.id               SecureRandom.hex
  json.name             result.name
end
