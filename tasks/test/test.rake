require 'rainbow'

namespace :test do

  Rake::TestTask.new(:core => 'codegen:generate_code') do |t|
    # Rake::Task['codegen:generate_code'].invoke
    t.libs << "test"
    t.libs << "lib"
    t.description = "Run core test"
    t.test_files = FileList['test/**/*_test.rb']
  end

  Rake::TestTask.new(:generated => 'codegen:generate_code') do |t|
    # Rake::Task['codegen:generate_code'].invoke
    t.libs << "test"
    t.libs << "lib"
    t.libs << "generate/lib"
    t.description = "Run gengerated test"
    t.test_files = FileList['generated/test/**/*_test.rb']
  end

  Rake::TestTask.new(:all => 'codegen:generate_code') do |t|
    t.libs << "test"
    t.libs << "lib"
    t.libs << "generate/lib"
    t.description = "Run all test"
    t.test_files = FileList['test/**/*_test.rb'] + FileList['generated/test/**/*_test.rb']
  end

end
