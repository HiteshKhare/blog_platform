class AddAnalyticsToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :total_reading_time, :integer, default: 0
  end
end
