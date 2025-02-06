class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])  # Find the post the comment belongs to
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user  # Associate the comment with the current user
    if @comment.save
      redirect_to post_path(@post), notice: 'Comment was successfully created.'
    else
      redirect_to post_path(@post), alert: 'There was an error creating your comment.'
    end
  end

  def destroy
    debugger
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy
    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
