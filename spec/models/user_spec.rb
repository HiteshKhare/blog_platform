require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe '#admin?' do
    let(:admin_user) { User.create(email: 'admintest@gmail.com', password: "password", password_confirmation: "password", admin: true) }
    let(:regular_user) { User.create(email: 'test@gmail.com', password: "password", password_confirmation: "password") }

    it 'returns true for admin users' do
      expect(admin_user.admin?).to be(true)
    end

    it 'returns false for regular users' do
      expect(regular_user.admin?).to be(false)
    end
  end
end
