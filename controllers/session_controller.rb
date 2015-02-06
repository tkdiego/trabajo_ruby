class Server < Sinatra::Base

	def session_enable
		if defined?(session[:id])
		  true
		else
		  redirect ("/login")
		end
	end

	def session_logout
		session.clear
		redirect '/'
	end

end