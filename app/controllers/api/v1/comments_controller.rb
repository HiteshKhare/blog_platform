module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post

      # POST /api/v1/posts/:post_id/comments
      def create
        comment = @post.comments.build(comment_params.merge(user: current_user))
        if comment.save
          render json: comment, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/posts/:post_id/comments
      def index
        comments = @post.comments.includes(:user)
        render json: comments.as_json(include: { user: { only: :email } }), status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
