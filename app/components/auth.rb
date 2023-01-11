module Auth
  def self.join_with_email(email)
    user = User.find_by(email: email)
    if user.nil?
      token = generate_create_account_link(email)
      puts "Generated account creation token: #{token}"
      
      NotifierUserMailer.with(email: email).new_account(token).deliver_later

      return {
        user: nil,
        fails: nil,
        action: :create_account
      }
    elsif user_blocked?(user.id)
      return {
        user: {email: user.email},
        fails: user_fails(user.id),
        action: :reset_password
      }
    else
      return {
        user: {email: user.email},
        fails: user_fails(user.id),
        action: :login
      }
    end
  end

  def self.login_with_email(email, password)
    email_status = join_with_email(email)

    if email_status[:action] != :login
      return email_status.merge({ message: :cant_login })
    end

    user = User.find_by(email: email)
    if user.password == password
      token = create_access_token(user.id)
      return {
        user: {email: user.email, id: user.id},
        fails: user_fails(user.id),
        action: :logged_in,
        token: token
      }
    else
      user_fail(user.id)
      if user_blocked?(user.id)
        token = generate_reset_password_link(user.id)
        puts "Generated reset pass token: #{token}"
        
        NotifierUserMailer.with(email: email).reset_password(user.id, token).deliver_later

        return {
          user: {email: user.email},
          fails: user_fails(user.id),
          action: :reset_password
        }
      else
        return {
          user: {email: user.email},
          fails: user_fails(user.id),
          action: :wrong_password
        }
      end
    end
  end

  def self.login_with_token(token, user_id)
    redis = Redis.new
    redis_key = RedisKeys.auth_token(token)

    if redis.get(redis_key) == user_id
      return :valid_token
    else
      return :token_fail
    end
  end

  def self.strong_password?(password)
    # todo
    true
  end

  def self.create_account(token, email, password)
    return {action: :weak_password} unless strong_password?(password)

    redis = Redis.new
    redis_key = RedisKeys.new_account_password_link(token)

    if redis.get(redis_key) == email
      user = User.create email: email, password: password
      token = create_access_token(user.id)
      redis.del redis_key
      return {
        user: {email: user.email, id: user.id},
        fails: user_fails(user.id),
        action: :logged_in,
        token: token
      }
    else
      return {
        user: nil,
        fails: nil,
        action: :create_account_fail
      }
    end
  end

  def self.reset_password(token, user_id, password)
    redis = Redis.new
    redis_key = RedisKeys.reset_password_link(token)

    if redis.get(redis_key) == user_id
      user = User.find user_id
      user.password = password
      user.save
      clear_user_fails(user_id)
      token = create_access_token(user.id)
      redis.del redis_key
      return {
        user: {email: user.email, id: user.id},
        fails: user_fails(user.id),
        action: :logged_in,
        token: token
      }
    else
      return {
        user: nil,
        fails: nil,
        action: :reset_password_fail
      }
    end
  end
  
  private

  def self.clear_user_fails(user_id)
    redis = Redis.new
    redis_key = RedisKeys.user_auth_fail(user_id)
    redis.del redis_key
  end

  def self.generate_reset_password_link(user_id)
    token = SecureRandom.hex(64)
    redis = Redis.new
    redis_key = RedisKeys.reset_password_link(token)
    redis_expiration = 7.days.to_i

    redis.set redis_key, user_id
    redis.expire redis_key, redis_expiration

    token
  end

  def self.generate_create_account_link(email)
    token = SecureRandom.hex(64)
    redis = Redis.new
    redis_key = RedisKeys.new_account_password_link(token)
    redis_expiration = 7.days.to_i

    redis.set redis_key, email
    redis.expire redis_key, redis_expiration

    token
  end

  def self.create_access_token(user_id)
    token = SecureRandom.hex(64)
    redis = Redis.new
    redis_key = RedisKeys.auth_token(token)
    redis_expiration = 7.hours.to_i

    redis.set redis_key, user_id
    redis.expire redis_key, redis_expiration

    token
  end

  def self.user_blocked?(user_id)
    redis = Redis.new
    key = RedisKeys.user_auth_fail(user_id)

    blocks = redis.get(key)
    blocks.to_i > 3
  end

  def self.user_fails(user_id)
    redis = Redis.new
    key = RedisKeys.user_auth_fail(user_id)

    fails = redis.get(key)
    ttl = redis.ttl(key)

    {
      amount: fails,
      ttl: ttl
    }
  end

  def self.user_fail(user_id)
    redis = Redis.new
    key = RedisKeys.user_auth_fail(user_id)

    block_count = redis.incr(key)
    redis.expire(key, (2**block_count).days.to_i) ## 2, 4, 8, ...
  end
end
