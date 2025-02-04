# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Create a regular user
User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password')

# Create an admin user
User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)

user = User.first
5.times do |i|
  post = user.posts.create!(
    title: "Post #{i + 1}",
    content: "Content of post #{i + 1}",
    views_count: rand(1..100),
    total_reading_time: rand(2..5)
  )
  tag = Tag.find_or_create_by(name: "tag#{i % 3}")
  post.tags << tag
  post.save
end
