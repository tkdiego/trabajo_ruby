require './server'
require 'sinatra/activerecord/rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/setup.rb']
  t.verbose = true
end
