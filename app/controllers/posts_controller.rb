class PostsController < ApplicationController
  POSTS_PER_PAGE = 10;
  PAGINATION_LIMIT = 9;

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    # @posts = Post.all.sort_by { |post| post.total_votes }.reverse
    @post_size = Post.count
    @page_number = params[:page]
    @pages = @post_size / POSTS_PER_PAGE + 1
    start_number = POSTS_PER_PAGE * (@page_number.to_i - 1)

    if @page_number && @post_size > start_number
      @posts = Post.limit(POSTS_PER_PAGE).offset(start_number)
        .sort_by { |post| post.total_votes }.reverse
    elsif !@page_number
      @page_number = 1;
      @posts = Post.limit(POSTS_PER_PAGE)
        .sort_by { |post| post.total_votes }.reverse
    else
      redirect_to posts_path
      return
    end

    respond_to do |format|
      format.html
      format.json { render json: @posts.map { |post| post.response_post } }
      format.xml { render xml: @posts.map { |post| post.response_post } }
    end
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.sort_by { |comment| comment.total_votes }.reverse

    respond_to do |format|
      format.html
      format.json { render json: @post.response_post }
      format.xml { render xml: @post.response_post }
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
    access_denied unless current_user == @post.creator || current_user.admin?
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Your post was updated."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = 'Your vote was counted.'
        else
          flash[:error] = 'You can only vote once.'
        end
        redirect_to :back
      end
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end
end
