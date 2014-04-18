class UsersController < ApplicationController
  load_and_authorize_resource :only => :administration
  #skip_authorize_resource :only => [:search,:show,:read,:parse_book]
  # def new
  # 	@user = User.new
  # end

  # def create
  # 	@user = User.new(params[:user])
  # 	if @user.save
  # 		redirect_to books_path, :notice => "Signed up!"
  # 	else
  # 		render "new"
  # 	end
  # end

  def administration
    
  end

end
