class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  ITEMS_PER_PAGE = 10
  PAGINATION_PER_PAGE = 10

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = 'Must be logged in to do that.'
      redirect_to root_path
    end
  end

  def require_admin
    access_denied unless logged_in? and current_user.admin?
  end

  def access_denied
    flash[:error] = "You're not allowed to do that."
    redirect_to root_path
  end

  def set_pagination
    items_per_page = ITEMS_PER_PAGE
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

  def set_pagination_range(current_page, page_count)
    pagination_limit = PAGINATION_PER_PAGE
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
end
