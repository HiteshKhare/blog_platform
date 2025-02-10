require 'rails_helper'

RSpec.describe PostsTag, type: :model do
  describe 'Associations' do
    it { should belong_to(:post) }
    it { should belong_to(:tag) }
  end
end
