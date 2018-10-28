class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show ,:followings, :folowers]

  def index
    @users = User.all.page(params[:page])
  
    
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
    counts(@user)
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "編集完了しました"
      redirect_to @user
    else
      flash[:danger] = "編集できませんでした"
      render :edit
      
    end
  end

  def new
    @user = User.new
  end
  
 

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザーを登録しました"
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def destroy
    
    User.find(params[:user_id]).destroy
    flash[:success] = "アカウントをけしました"
    redirect_to (root_url)
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
   
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def favorites
    @user = User.find(params[:id])
    
    @posts = @user.favoritings.order('created_at DESC').page(params[:page])
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :picture ,:profile)
  end
end
