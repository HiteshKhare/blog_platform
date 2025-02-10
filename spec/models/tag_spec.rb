require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Associations' do
    it { should have_and_belong_to_many(:posts).join_table("posts_tags") }
    it { should have_many(:posts_tags).dependent(:destroy) }
  end
end
