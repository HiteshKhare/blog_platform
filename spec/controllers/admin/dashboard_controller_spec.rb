require 'rails_helper'
require 'factory_bot'

RSpec.describe Admin::DashboardController, type: :controller do
  let(:regular_user) { User.create(email: 'test@gmail.com', password: "password", password_confirmation: "password") }
  let(:admin_user) { User.create(email: 'test@gmail.com', password: "password", password_confirmation: "password", admin: true) }
  let(:post) { Post.create(user: regular_user, title: 'Sample Post', content: 'This is a test content with multiple words.') }

  describe 'GET #index' do
    context 'when an admin user is logged in' do
      before do
        sign_in admin_user
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'fetches all users with their posts' do
        expect(assigns(:users)).to eq(User.includes(:posts).all)
      end
    end

    context 'when a regular user is logged in' do
      before do
        sign_in regular_user
        get :index
      end

      it 'redirects to the root path with an alert' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access Denied')
      end
    end

    context 'when no user is logged in' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
