Rails.application.config.cache_store = :redis_store, ENV['MEM_STORAGE_URL'], { namespace: 'cache' }
