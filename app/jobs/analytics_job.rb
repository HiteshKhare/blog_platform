class AnalyticsJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    post.increment!(:view_count)
  end
end
