module Features
  class Control
    def initialize(user_id, token)
      access = Clients::Auth.login_with_token(token, user_id)
      raise "Invalid token" unless access == :valid_token

      @user = User.find(user_id)
    end

    def access?(feature)
      return false if @user.feature_control[feature.to_s].nil?
      return true if @user.feature_control[feature.to_s][:to_lifetime]
      return true if @user.feature_control[feature.to_s][:period] > Time.now

      false
    end

    def enable(feature, {period = 1.month.from_now, to_lifetime = false})
      @user.feature_control[feature.to_s] = {period: period, to_lifetime: to_lifetime}
      @user.save
    end
  end
end
