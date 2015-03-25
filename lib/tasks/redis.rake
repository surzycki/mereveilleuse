namespace :redis do
  desc 'Flush Redis DB'
  task flushdb: :environment do
    client = Redis.new(url: ENV['REDIS_URL'])
    client.flushdb
    puts "#{ENV['REDIS_URL']} flushed"
  end
end