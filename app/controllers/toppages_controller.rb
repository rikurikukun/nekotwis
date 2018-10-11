class ToppagesController < ApplicationController
  def index
    if logged_in?
     @post = current_user.posts.build
     @mposts = current_user.posts.order('created_at DESC').page(params[:page])
    end
  end
end
