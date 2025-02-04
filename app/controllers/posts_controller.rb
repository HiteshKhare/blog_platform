class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:analytics]

  def index
    if params[:search].present? && params[:tag].present?
      @posts = Post.joins(:tags).where('posts.title LIKE ? OR posts.content LIKE ? OR tags.name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
                     .where(tags: { id: params[:tag] })
                     .distinct.page(params[:page])
    elsif params[:search].present?
      @posts = Post.joins(:tags).where('posts.title LIKE ? OR posts.content LIKE ? OR tags.name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
                     .distinct.page(params[:page])
    elsif params[:tag].present?
      @posts = Tag.find(params[:tag]).posts.page(params[:page])
    else
      @posts = Post.all.page(params[:page])
    end
  end

  def show
    @post.increment_views!  # Track the view count each time the post is viewed
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  def analytics
    @most_viewed_posts = Post.order(views_count: :desc).limit(5)
    @average_reading_time = Post.average(:total_reading_time)
    @popular_tags = Tag.joins(:posts).group('tags.id').order('count(posts.id) desc').limit(5)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
	  params.require(:post).permit(:title, :content, tag_ids: [])
	end

  def check_admin
    redirect_to root_path, alert: 'Access denied' unless current_user.admin?
  end
end
