require 'bundler/setup'
require 'coffee-script'

namespace :js do
  desc "compile coffee-scripts"
  task :compile do
    File.open "#{File.dirname(__FILE__)}/js/slides.js", 'w+' do |js|
      Dir.chdir("#{File.dirname(__FILE__)}/coffee/") do
        ['util.coffee', 'background.coffee', 'slide.coffee', 'slidemanager.coffee'].each do |f|
          js.puts CoffeeScript.compile File.read(f) 
        end
      end
    end
  end
end

namespace :less do
  desc "compile less"
  task :compile do
    Dir.chdir("#{File.dirname(__FILE__)}/less/") do
      Dir.foreach(".") do |cf|
        if /^([^_].+)\.less$/ =~ cf
          name = $1
          puts "Treating #{cf} ..."
          File.open("../css/#{name}.css", "w+") do |css|
            file = File.join(File.dirname(__FILE__),"less", cf)
            oc = `lessc #{file}`
            css.puts oc
          end
        end
      end
    end
  end
end

