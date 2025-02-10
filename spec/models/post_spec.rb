require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_and_belong_to_many(:tags) }
    it { should have_many(:posts_tags).dependent(:destroy) }
    it { should have_many(:post_views).dependent(:destroy) }
  end

  describe 'instance methods' do
    let(:user) { User.create(email: 'test@gmail.com', password: "password", password_confirmation: "password") }
    let(:post) { Post.create(user: user, title: 'Sample Post', content: 'This is a test content with multiple words.') }

    describe '#reading_time' do
      it 'calculates reading time correctly' do
        allow(post).to receive(:word_count).and_return(400)
        expect(post.reading_time).to eq(2)
      end
    end

    describe '#increment_reading_time!' do
      it 'increments total reading time correctly' do
        post.increment_reading_time!(5)
        expect(post.total_reading_time).to eq(5)
      end
    end
  end

  describe 'private methods' do
    describe '#word_count' do
      it 'counts words correctly' do
        post = Post.new(content: 'This is a simple post content.')
        expect(post.send(:word_count)).to eq(6)
      end
    end
  end
end
