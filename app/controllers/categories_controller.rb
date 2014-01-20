class CategoriesController < ApplicationController
  before_action :require_user, only: [:new, :create]
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))

    if @category.save
      flash[:notice] = 'Your category was created.'
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @posts = @category.posts.sort_by { |post| post.total_votes }.reverse
  end
end