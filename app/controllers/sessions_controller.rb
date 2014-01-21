class SessionsController < ApplicationController

	def new
		
	end


	def create
	  #SIGN IN MEANS user EXISTS SO WE CREATE user varible AND FIND THE user
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
        #Sign in user and redirect to the user's show page
        sign_in user
        #redirect_to user
        redirect_back_or user
	  else
	  	#Create an error message and re-render the signin form
	  	flash.now[:error] = "Invalid email/password combination"
	  	render 'new'
 	  end
	end


	def destroy
		sign_out
		redirect_to root_url
	end
end
