class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, join_table: "posts_tags"
  has_many :posts_tags, dependent: :destroy
  has_many :post_views, dependent: :destroy

  def reading_time
    (word_count / 200.0).ceil  # Assuming average reading speed of 200 words per minute
  end

  # Method to track reading time
  def increment_reading_time!(time)
    self.total_reading_time += time
    save!
  end

  private

  def word_count
    content.split(/\s+/).size  # Count words by splitting on spaces
  end
end
