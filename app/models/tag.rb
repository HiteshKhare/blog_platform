class Tag < ApplicationRecord
  has_and_belongs_to_many :posts, join_table: "posts_tags"
  has_many :posts_tags, dependent: :destroy
end
