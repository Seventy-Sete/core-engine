# frozen_string_literal: true

module FeaturesControl
  class Enable < ApplicationService
    attr_reader :user, :feature, :period, :to_lifetime

    def initialize(user, feature, period: 1.month.from_now, to_lifetime: false)
      @user = user
      @feature = feature
      @period = period
      @to_lifetime = to_lifetime
    end

    def call
      @user.feature_control[feature.to_s] = { period:, to_lifetime: }
      @user.save
    end
  end
end
