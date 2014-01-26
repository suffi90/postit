class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  ITEMS_PER_PAGE = 10
  PAGINATION_PER_PAGE = 10

  def index
    set_pagination
    if !@pagination[:redirect_to_first]
      @posts = Post.limit_posts(ITEMS_PER_PAGE, @pagination[:offset])
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
    @comments = @post.comments

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
    @post.save if @vote.valid?

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

  def set_pagination
    current_page = (params[:page] ||= 1).to_i
    post_size = Post.count
    if post_size % ITEMS_PER_PAGE == 0
      page_count = post_size / ITEMS_PER_PAGE
    else
      page_count = post_size / ITEMS_PER_PAGE + 1
    end
    @pagination = {
      current: current_page,
      offset: (current_page - 1) * ITEMS_PER_PAGE,
      page_count: page_count,
      redirect_to_first: current_page < 1 || current_page > page_count
    }
  end
end
