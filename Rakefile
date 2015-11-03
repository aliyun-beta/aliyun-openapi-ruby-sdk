require "bundler/gem_tasks"
require "rake/testtask"

FileList['tasks/**/*.rake'].each do |file|
	load file
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb'] + FileList['generated/test/**/*_test.rb']
end

task :default => :test