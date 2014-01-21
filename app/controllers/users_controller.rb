class UsersController < ApplicationController
  
  # AUTHORIZE ONLY SIGNED IN USER TO EDIT AND UPDATE
  before_action :signed_in_user, only: [:edit, :update]
  # ENSURE WE AUTHORIZE RIGHT USER TO EDIT AND UPDATE ie ACCOUNT OWNER TO EDIT AND UPDATE THEIR ACCOUNT
  before_action :right_user, only: [:edit, :update]
  # BEFORE FILTER RESTRICTING THE DESTROY ACTIO TO ADMINS
  before_action :admin_user, only: :destroy

  def new
   @user = User.new
  end


  def create
    @user = User.new(user_params)  
    if @user.save
      sign_in @user #SIGN IN USER UPON SIGN UP
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    else
      render 'new'
    end
  end


  def show
    @user = User.find(params[:id])
  end

  def index
    #@users = User.all
    # FROM paginate(page: 1) TO paginate(page: params[:page]) therefore
    @users = User.paginate(page: params[:page])
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile has been updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end
  

  private

  # STRONG PARAMETERS
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  
  # BEFORE FILTERS
  def signed_in_user
    unless signed_in?
      store_location # THIS HANDLES FRIENDLY FORWARDING IN SESSIONS CONTROLLER
      flash[:notice] = "Please Sign in."
      redirect_to signin_url
    end
  end

  def right_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      redirect_to root_url 
    end
  end

  def admin_user
    unless current_user.admin?
      redirect_to root_url
    end
  end

end
