require_relative 'test_game'
require_relative 'test_player'
DatabaseCleaner.strategy = :transaction

set :test, File.dirname("./test/**")

class MiniTest::Test
  before :test do
    DatabaseCleaner.start
  end

  after :test do
    DatabaseCleaner.clean
  end
end
