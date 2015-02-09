ENV['RACK_ENV'] = 'test'

require './server'
require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

class MiniTest::Test

	def setup		
		DatabaseCleaner.start
	end

	def teardown
		DatabaseCleaner.clean
	end

end



Dir["./test/**"].each do |t|
  require t
end
