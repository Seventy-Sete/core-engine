# frozen_string_literal: true

module AccountManager
  include Storage::Keys
  extend ActiveSupport::Concern

  def user_blocked?(_user_id)
    redis = Redis.new
    key = format(USER_AUTH_FAIL, user_id: user.id)

    blocks = redis.get(key)
    blocks.to_i > 3
  end

  def user_fails(_user_id)
    redis = Redis.new
    key = format(USER_AUTH_FAIL, user_id: user.id)

    fails = redis.get(key)
    ttl = redis.ttl(key)

    {
      amount: fails,
      ttl:
    }
  end

  def clear_user_fails(_user_id)
    redis = Redis.new
    redis_key = format(USER_AUTH_FAIL, user_id: user.id)
    redis.del redis_key
  end

  def user_fail(_user_id)
    redis = Redis.new
    key = format(USER_AUTH_FAIL, user_id: user.id)

    block_count = redis.incr(key)
    redis.expire(key, (2**block_count).days.to_i)
  end
end
