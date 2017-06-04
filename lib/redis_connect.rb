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

  def hadd(key, value, options={})
    return false if @redis.exists(key)
    if @redis.mapped_hmset(key, value) == 'OK'
      @redis.expire(key, options[:ex]) if options[:ex]
      return true
    end
    false
  end

  def method_missing(name, *args, &block)
    if @redis.respond_to?(name)
      @redis.send(name, *args, &block)
    else
      super
    end
  end
end