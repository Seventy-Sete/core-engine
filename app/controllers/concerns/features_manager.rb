# frozen_string_literal: true

module FeaturesControl
  extend ActiveSupport::Concern

  def have_access_to?(user, feature)
    return false if user.feature_control[feature.to_s].nil?
    return true if user.feature_control[feature.to_s]['to_lifetime']
    return true if user.feature_control[feature.to_s]['period'] > Time.now

    false
  end
end
