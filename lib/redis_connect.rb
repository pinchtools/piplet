require 'redis'

class RedisConnect
  def initialize
    @redis = Redis.new( url: ENV['CACHE_SERVER_URL'] )
  end

  def get(key)
    @redis.get(key)
  end

  def set
    @redis.set(key, value, options)
  end

  def add(key, value, options={})
    options[:nx] = true # set key if not exists
    @redis.set(key, value, options) #return boolean
  end
end