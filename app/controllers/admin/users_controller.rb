class Admin::UsersController < Admin::ResourceController
  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      sign_in @user, :bypass => true
      redirect_to admin_root_path
    else
      render :edit_password
    end
  end 

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end