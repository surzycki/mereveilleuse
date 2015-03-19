Geocoder.configure(
  # geocoding service (see below for supported options):
  lookup: :google,

  # IP address geocoding service (see below for supported options):
  ip_lookup: :maxmind,

  # geocoding service request timeout, in seconds (default 3):
  timeout: 15,

  # set default units to kilometers:
  units: :km,

  # caching (see below for details):
  cache: Redis.new(url: ENV['REDIS_URL']),
  cache_prefix: 'geocode',

  language: :fr
)