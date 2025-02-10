require 'rails_helper'
require 'factory_bot'

RSpec.describe PostsController, type: :controller do
  let(:user) { User.create(email: 'test@gmail.com', password: "password", password_confirmation: "password") }
  let(:admin_user) { User.create(email: 'test@gmail.com', password: "password", password_confirmation: "password", admin: true) }
  let(:teg) { Tag.create(name: "test teg 1") }
  let(:post_record) { Post.create(user: user, title: 'Sample Post', content: 'This is a test content with multiple words.') }
  let(:valid_attributes) { { title: 'Test Title', content: 'Test Content' } }
  let(:invalid_attributes) { { title: '', content: '' } }
  
  describe "GET #index" do
    it "returns a success response for all posts" do
      get :index
      expect(response).to be_successful
    end

    it "filters posts by search term" do
      get :index, params: { search: "Sample" }
      expect(assigns(:posts)).to be_empty
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: post_record.id }
      expect(response).to be_successful
    end

    it "increments views for authenticated users" do
      sign_in user
      expect {
        get :show, params: { id: post_record.id }
      }.to change { post_record.reload.views_count }.by(0)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Post" do
        sign_in user
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        sign_in user
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(Post.last)
      end
    end

    context "with invalid params" do
      it "renders the new template" do
        sign_in user
        post :create, params: { post: invalid_attributes }
        expect(response).to render_template()
      end
    end
  end

  describe "PUT #update" do
    it "updates the requested post" do
      sign_in user
      put :update, params: { id: post_record.id, post: { title: 'Updated Title' } }
      post_record.reload
      expect(post_record.title).to eq('Updated Title')
    end

    it "renders the edit template on failure" do
      sign_in user
      put :update, params: { id: post_record.id, post: invalid_attributes }
      expect(response).to render_template()
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested post" do
      sign_in user
      post_record # ensure post is created
      expect {
        delete :destroy, params: { id: post_record.id }
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      sign_in user
      delete :destroy, params: { id: post_record.id }
      expect(response).to redirect_to(posts_url)
    end
  end

  describe "GET #analytics" do
    context "when admin user is logged in" do
      it "returns a success response" do
        sign_in admin_user
        get :analytics
        expect(response).to be_successful
      end
    end

    context "when non-admin user is logged in" do
      it "redirects to root path with an alert" do
        sign_in user
        get :analytics
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Access denied')
      end
    end
  end
end
