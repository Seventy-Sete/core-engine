class AddFeatureControl < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :feature_control, :jsonb, default: {}
  end
end
