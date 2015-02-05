class Server < Sinatra::Base

	def session_enable
    if defined?(session[:enable]) && session[:enable]
      true
    else
      redirect ("/login")
    end
	end
  
  def session_logout
		session.clear
		session[:enable]=false
		redirect '/'
	end
end