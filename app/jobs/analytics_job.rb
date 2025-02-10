class AnalyticsJob < ApplicationJob
  queue_as :default

  def perform(post, user)
    unless post.post_views.exists?(user: user)
      post.post_views.create(user: user)  # Create a record in the post_views table
      increment!(:views_count)  # Increment the views count
    end
  end
end
