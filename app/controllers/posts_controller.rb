class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    set_pagination
    if !@pagination[:redirect_to_main]
      @posts = Post.limit(ApplicationController::ITEMS_PER_PAGE)
        .offset(@pagination[:offset])
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

  def set_pagination_range(current_page, page_count)
    pagination_limit = ApplicationController::PAGINATION_PER_PAGE
    return [*1..page_count] if page_count <= pagination_limit

    if current_page > pagination_limit/2
      if page_count <= (current_page - pagination_limit/2 + pagination_limit)
        min = page_count - pagination_limit + 1
        max = page_count
      else
        min = current_page - pagination_limit/2 + 1
        max = min + pagination_limit - 1
      end
      [*min..max]
    else
      [*1..pagination_limit]
    end
  end

  def set_pagination
    items_per_page = ApplicationController::ITEMS_PER_PAGE
    current_page = (params[:page] ||= 1).to_i
    post_size = Post.count
    if post_size % items_per_page == 0
      page_count = post_size / items_per_page
    else
      page_count = post_size / items_per_page + 1
    end
    @pagination = {
      current: current_page,
      offset: (current_page - 1) * items_per_page,
      page_count: page_count,
      redirect_to_main: current_page < 1 || current_page > page_count,
      pagination_range: set_pagination_range(current_page, page_count)
    }
  end
end
