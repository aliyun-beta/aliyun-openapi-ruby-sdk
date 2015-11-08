require "bundler/gem_tasks"
require "rake/testtask"

FileList['tasks/**/*.rake'].each do |file|
	load file
end

task :default => 'test:all'