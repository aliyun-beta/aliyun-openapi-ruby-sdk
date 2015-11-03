require "bundler/gem_tasks"
require "rake/testtask"

FileList['tasks/**/*.rake'].each do |file|
	load file
end

Rake::TestTask.new(:test) do |t|
  # Rake::Task['codegen:generate_code'].invoke
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

Rake::TestTask.new(:test_generated) do |t|
  # Rake::Task['test'].invoke
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['generated/test/**/*_test.rb']
end

task :default => :test