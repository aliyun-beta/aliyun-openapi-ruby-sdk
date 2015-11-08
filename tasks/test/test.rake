require 'rainbow'

namespace :test do
  Rake::TestTask.new(:core) do |t|
    # Rake::Task['codegen:generate_code'].invoke
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList['test/**/*_test.rb']
  end

  Rake::TestTask.new(:generated) do |t|
    # Rake::Task['test'].invoke
    t.libs << "test"
    t.libs << "lib"
    t.libs << "generate/lib"
    t.test_files = FileList['generated/test/**/*_test.rb']
  end


  Rake::TestTask.new(:all) do |t|
    # Rake::Task['codegen:generate_code'].invoke
    t.libs << "test"
    t.libs << "lib"
    t.libs << "generate/lib"
    t.test_files = FileList['test/**/*_test.rb'] + FileList['generated/test/**/*_test.rb']
  end

end