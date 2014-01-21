module SessionsHelper

	def sign_in(user)
	  # CREATE NEW TOKEN
	  remember_token = User.new_remember_token
	  # PLACE UNENCRYPTED TOKEN IN BROWSER COOKIES
    cookies.permanent[:remember_token] = remember_token
    # SAVE ENCRYPTED TOKEN TO DATABASE WHILE BYPASSING VALIDATIONS USING update_attribute
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    # SET CURRENT_USER EQUAL TO GIVEN USER
    self.current_user = user
	end

  # self.current_user = user IS AN ASSIGNMENT WHICH WE MUST DEFINE ie DEFINING AN ASSIGNMENT
	def current_user=(user)
    @current_user = user
	end


	def current_user
	  # GET UNENCRYPTED TOKEN FROM THE BROWSER AND THEN ENCRYPT IT
    remember_token = User.encrypt(cookies.permanent[:remember_token])
    # SET CURRENT USER TO USER CORRESPONDING TO REMEMBER TOKEN. find_by CALLED ATLEAST ONCE EVERYTIME
    # USER VISITS A PAGE ON THE SITE.
    # @current_user RETURNED ON SUBSEQUENT INVOCATIONS WITHOUT HITTING THE DATABASE
    @current_user = @current_user || User.find_by(remember_token: remember_token)
  end

    
  def signed_in?
     # USER IS signed_in IF THE current_user IS NOT nil, ie THERE IS A CURRENT USER
     !current_user.nil?
  end


  def sign_out
    # CHANGE CURRENT USER'S REMEMBER TOKEN IN THE DATABASE (DONE FOR SECURITY IN CASE ITS STOLEN)
    current_user.update_attribute(:remember_token,User.encrypt(User.new_remember_token))
    # USE DELETE METHOD ON COOKIES TO REMOVE TOKEN FROM SESSION
    cookies.delete(:remember_token)
    # OPTIONAL STEP, SET CURRENT USER TO NIL
    self.current_user = nil
  end

  # ADDED TO CORRESPOND TO THE right_user BEFORE FILTER/BEFORE ACTION IN THE USERS CONTROLLER
  def current_user?(user)
    user == current_user
  end

  
  # CODE TO IMPLEMENT FRIENDLY FORWARDING:
  # FIRST STORE URL OF PROTECTED PAGE THAT IS ACCESSED BY USER WHO IS NOT LOGGED IN
  def store_location
    if request.get?
      session[:return_to] = request.url
    end
  end
  # WHEN USER SIGNS IN, WE REDIRECT TO THAT URL IF IT EXISTS OR REDIRECT TO SOME 
  # DEFAULT IN THE SESSIONS CONTROLLER'S create ACTION
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

end
