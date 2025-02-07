module Api
  module V1
    class PostsController < ApplicationController

      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_post, only: [:show, :update, :destroy, :add_comment, :get_comments]

      # GET /api/v1/posts
      def index
        posts = Post.all.page(params[:page])
        render json: posts, status: :ok
      end

      # GET /api/v1/posts/:id
      def show
        @post.increment_views!(current_user)
        render json: @post.as_json(include: { tags: { only: :name }, comments: { include: :user } }), status: :ok
      end

      # POST /api/v1/posts
      def create
        post = current_user.posts.build(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/posts/:id
      def update
        if @post.update(post_params)
          render json: @post, status: :ok
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/posts/:id
      def destroy
        @post.destroy
        head :no_content
      end

      # POST /api/v1/posts/:post_id/comments
      def add_comment
        comment = @post.comments.build(comment_params.merge(user: current_user))
        if comment.save
          render json: comment, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/posts/:post_id/comments
      def get_comments
        comments = @post.comments.includes(:user)
        render json: comments.as_json(include: { user: { only: :email } }), status: :ok
      end

      # GET /api/v1/posts/analytics
      def analytics
        most_viewed_posts = Post.order(views_count: :desc).limit(5)
        average_reading_time = Post.average(:total_reading_time)
        popular_tags = Tag.joins(:posts).group('tags.id').order('count(posts.id) desc').limit(5)

        analytics_data = {
          most_viewed_posts: most_viewed_posts.as_json(only: [:id, :title, :views_count]),
          average_reading_time: average_reading_time.to_f.round(2),
          popular_tags: popular_tags.as_json(only: [:id, :name])
        }

        render json: analytics_data, status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :content, tag_ids: [])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
