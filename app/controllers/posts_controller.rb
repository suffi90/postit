class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    post = Post.new(post_params)

    if @post.save
      flas[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update

  end

  private

  def post_params
    params.require(:post).permit! # permit! permits everything
  end
end
