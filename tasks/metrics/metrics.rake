# require 'rainbow'
# require 'yaml'
#
# namespace :metrics do
#   desc "cloc to check test code percentage"
#   task :cloc do
#     # Rake::Task['codegen:generate_code'].invoke
#     code =`bin/cloc --csv lib generated/lib | tail -1`
#     files,language,blank,comment,sys_code = code.strip.split(',')
#     puts "#{Rainbow('Total Code').green} :  #{file} Files, #{blank} blank lines, #{comment} comment lines, #{sys_code} actual lines"
#     test = `bin/cloc --csv test generated/test | tail -1 `
#     files,language,blank,comment,test_code = test.strip.split(',')
#     puts "#{Rainbow('Test  Code').yellow} :  #{file} Files, #{blank} blank lines, #{comment} comment lines, #{test_code} actual lines"
#     percentage = test_code.to_i * 1.0 / (sys_code.to_i + test_code.to_i)
#     color = percentage > 0.3 ? :green : :red
#     puts "#{Rainbow("Test Code Percentage : #{(percentage * 100).round(2)} %").send(color)}"
#   end
#
# end
