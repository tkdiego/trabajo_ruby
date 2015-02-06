class Server < Sinatra::Base

	def session_enable 
		redirect("/login") unless session[:enable]
	end
  
  def session_logout
		session[:enable]=false
		redirect '/'
	end

end