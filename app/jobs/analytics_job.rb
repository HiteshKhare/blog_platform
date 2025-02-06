class AnalyticsJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    post.increment!(:views_count)
  end
end
