require 'find'
require 'json'
require 'rainbow'

namespace :meta do
  desc "validate meta"
  task :validate do
    errors = []
    Find.find('openapi-meta') do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == ?.
          Find.prune # Don't look any further into this directory.
        else
          next
        end
      else
        begin
          JSON.parse(File.read(path)) if File.basename(path).end_with?('.json')
          puts "#{Rainbow('[VALID]').green} ..... #{path}"
        rescue
          puts "#{Rainbow('[INVALID]').red} ... #{path}"
          errors << path
        end
      end
    end
    errors.empty? ? puts(Rainbow('ALL PASSED').green) : puts(Rainbow("FAILED #{errors.count}").red)

  end

  desc "list all methods"
  task :methods do 
    puts `grep -R method openapi-meta | sed "s/.*://g" | sort | uniq`
  end


  desc "list patterns"
  task :pattern do
    puts `grep -R pattern openapi-meta | sed "s/.*://g" | sort | uniq`
  end

  desc "list types"
  task :types do
    puts `grep -R type openapi-meta | sed "s/.*://g" | sort | uniq`
  end
end